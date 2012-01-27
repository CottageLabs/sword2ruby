#connection.rb

require 'uri'
require 'net/https'

module Sword2Ruby
  class Connection
    
    #the IRI (URI/URL) of the Service Document
    attr_reader :service_document_uri;
    
    #User Name & Password to Authenticate with
    attr_writer :username, :password;

    # If depositing on behalf of someone else, this is his/her username
    attr_accessor :on_behalf_of;
    
    def initialize(service_document_uri, username=nil, password=nil)
      @service_document_uri = URI.parse(service_document_uri);

      case @service_document_uri.scheme.downcase.to_sym
      when :http, :https
        puts "its a url"
      when :file
        puts "its a file"
      else
        raise URI::InvalidURIError, "Service Document URI could not be parsed: #{service_document_uri}"
      end
        

      
      @username = username;
      @password = password;
    end #initialize    
    
    def getServiceDocument
      dorequest("get", @service_document_uri.to_s, nil,{})
    end
    
    
    private


    # wrap request in a redirect follower, up to 10 levels by default
    def dorequest(verb,path,body = nil,headers = {},limit = 10)
      raise SwordException, 'HTTP redirection is too deep...cannot retrieve requested path: ' + path if limit == 0
      response = request(verb,path,body,headers)
      #determine response
      case response
        when Net::HTTPSuccess     then response
        when Net::HTTPRedirection then dorequest(verb,response['location'],body,headers,limit - 1)
      else
        response.error!
      end
    end

    # send request to the sword server
    def request(verb,path,content,headers = {},attempts = 0,&block)

      # get the content open for sending
      if !content.nil? and File.exists?(content)
        if headers.has_key?('Content-Type')
          if headers['Content-Type'].match('^text\/.*') #check if MIME Type begins with "text/"
            body = File.open(content) # open as normal (text-based format)
          else
            body = File.open(content, 'rb') # open in Binary file mode
          end
        else
          body = File.open(content, 'rb') # open in Binary file mode
        end
      else
        body = content
      end

      # If body was already read once, may need to rewind it
      body.rewind if body.respond_to?(:rewind) unless attempts.zero?      

      # build "request" procedure
      requester = Proc.new do 

        # init request type
        request = Net::HTTP.const_get(verb.to_s.capitalize).new(path.to_s, headers)

        # set standard auth request headers
        request['User-Agent'] ||= "Ruby SWORD Client"
        request.basic_auth @username, @password if @username and @password
        request['On-Behalf-Of'] ||= @on_behalf_of.to_s if @on_behalf_of

        if body
          # if body can be read, stream it
          if body.respond_to?(:read)                                                                
            request.content_length = body.respond_to?(:lstat) ? body.lstat.size : body.size
            request.body_stream = body
          else
            # otherwise just add as is
            request.body = body                                                                     
          end
        end

        @connection.request(request, &block)
      end

      # do the request
      @connection.start(&requester)
    rescue Errno::EPIPE, Timeout::Error, Errno::EPIPE, Errno::EINVAL
      # try 3 times before failing altogether
      attempts == 3 ? raise : (attempts += 1; retry)
    rescue Errno::ECONNREFUSED => error_msg
      raise SwordException, "connection to sword Server (path='#{path}') was refused! Is it up?\n\nUnderlying error: " + error_msg
    end      
    
  end  #class
end #module