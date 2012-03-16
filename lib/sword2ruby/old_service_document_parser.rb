require 'rexml/streamlistener'

# service_document_parser.rb
#
# Uses REXML in stream mode to extract important
# information from a SWORD Service Document.  This method parses
# the SWORD Service Document into a SwordClient::ParsedServiceDoc
#
# Gathers an array of all available Collections found
# in that Service Document.  Each Parsedcollection is
# represented by a Hash of the following general structure
# (which mirrors SWORD service document structure under <collection> tag):
#
# :collections =>
#   {'title' => <Parsedcollection Title>,
#    'abstract' => <Parsedcollection Description>,
#    'deposit_url' => <Parsedcollection Deposit URL>,
#    'accept' => <Accepted MIME Types>,
#    'acceptPackaging' =>
#         {'rank' => <format rank between 0-1>,
#          'value' => <Accepted package format> },
#    'collectionPolicy' => <Parsedcollection License / Policy>,
#    'mediation' => <Whether or not Mediation is supported>,
#    'treatment' => <SWORD treatment statement> }
#
# Also parses out general information about the SWORD server:
#
# :repository_name => <Name of the Repository>
# :version => <Version of SWORD supported>
# :max_upload_size => <Maximum size of upload>
# :verbose => <Verbose mode allowed?>
# :no_op => <No operation mode supported?>
#
module Sword2Ruby
class OldServiceDocumentParser
  #based of the REXML StreamListener
  include REXML::StreamListener
  
  attr_accessor :service_collections
  attr_accessor :service_properties
  
  # Name of a collection tag (used to parse out specific info for each collection)
  SWORD_PREFIX = "sword:"
  COLLECTION_TAG = "collection"
  ATOM_TITLE_TAG = "atom:title"
  SWORD_SERVICE_TAG = "sword:service"
  ACCEPT_PACKAGING_TAG = "sword:acceptPackaging"
  ACCEPT_TAG = "accept"
  
  
  
  
  # Name of SWORD's "acceptPackaging" tag (used to parse out the 'ranking' for each package format)
  

  @accept_packaging_rank = 0;

  def initialize()
    # initialise collections and properties
    @service_collections = []
    @service_properties = {}
    
    @current_collection_properties = nil  #current collection's hash
    @current_tag_name = nil    #name of current XML tag in the stream
  end

  #Processing when a start tag is encountered (e.g. <sword>)
  def tag_start(name, attrs)

    #save current tag name for later (for usage in text() method below)
    @current_tag_name = name

    #if starting a <app:collection> tag
    if (@current_tag_name == COLLECTION_TAG)
      #Initialize current collection's info, starting with its Deposit URL
      @current_collection_properties = {}
      attrs.each { |key,value| @current_collection_properties[tag_to_property_name(key)] = value }
      
    #special case to rename the current tag
    elsif (@current_tag_name == ACCEPT_TAG and attrs["alternate"]=="multipart-related")
      @current_tag_name = @current_tag_name + "_alternate_multipart_related"
      
    #Special case: the <acceptPackaging> tag includes a numerical ranking between
    # 0 and 1 for each accepted format -- this ranking indicates the preferred format(s)
    elsif (@current_tag_name == ACCEPT_PACKAGING_TAG)
        #If a "q" attribute is not found, assume this format is strongest preference (1.0)
        @accept_packaging_rank = attrs["q"] ? attrs["q"].to_f : 1.0
    end
  end
  
  
  #Processing when a Text Node is encountered
  def text(text)
    #convert value to string and strip off leading/trailing spaces
    value = text.to_s.strip

    #do nothing if empty value
    return if value.nil? or value.empty? or @current_tag_name.nil?
    
    property_name = tag_to_property_name(@current_tag_name)
    
    # if we are inside a <collection> tag
    # save the text as the value of the current XML tag
    if @current_collection_properties and @current_tag_name and !@current_tag_name.empty? and (@current_tag_name != COLLECTION_TAG)

        # Save text as a property of the current collection

        # Special case:  For the <acceptPackaging> tag, the value is a hash
        #  of the ranking ("q") and the packaging format.
        if (@current_tag_name == ACCEPT_PACKAGING_TAG)
          @current_collection_properties[property_name] ||= [] #initialise array if not already initialised
          @current_collection_properties[property_name] << {:rank=>@accept_packaging_rank, :uri=>value} #append to array
                    
        elsif (@current_tag_name == SWORD_SERVICE_TAG)
          @current_collection_properties[property_name] ||= [] #initialise array if not already initialised
          @current_collection_properties[property_name] << value #append to array
          
        else #general case
          @current_collection_properties[property_name] = value
        end
    
    #If we aren't in a collection, and we encounter an <atom:title>, 
    # then we've found the repository.rb's name
    # Save any global properties encountered
    elsif !@current_collection_properties and @current_tag_name and
        (@current_tag_name == ATOM_TITLE_TAG or @current_tag_name.start_with?(SWORD_PREFIX))
      @service_properties[property_name] = value
    end #if
  end #text
 
  #Processing when an end tag is encountered  (e.g. </sword>)
  def tag_end(name)
    
    #if ending a </app:collection> tag
    if (name == COLLECTION_TAG)
      #finished with our current collection, save it and clear out current collection
      @service_collections << Collection.new(@current_collection_properties)
      @current_collection_properties = nil
    end
    
    #clear out current tag name, no matter what
    @current_tag_name = nil
  end


  ##################
  # Private Methods
  ##################
  private
  
  #Convert an XML tag to a valid property name
  # (e.g. "atom:title" becomes :atom_title)
  def tag_to_property_name(tag_name)
      tag_name.nil? ? nil : tag_name.gsub(/:/, '_').to_sym
  end
  
  
end #class
end #module
