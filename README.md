SWORD2RUBY LIBRARY
==================

Introduction
------------
The Sword2Ruby library provides SWORD client functionality when run against a SWORD 2.0 compliant server.
It eases integration of Ruby applications with Sword servers, taking care of things like authentication,
deposit-receipts and the parsing of Sword extensions to Atom.

It was developed as part of the JISC SWORD 2.0 project. For more information on Sword, see:
http://www.swordapp.org/

This code lives at https://github.com/CottageLabs/sword2ruby.

Requirements
------------
In order to use the Sword2Ruby gem, you will require:-

*	A Sword 2.0 compliant server, such as Simple Sword Server 2 by Richard Jones:
	https://sword-app.svn.sourceforge.net/svnroot/sword-app/sss/branches/sss-2/
*	The atom-tools gem (version 2.0.5): https://github.com/bct/atom-tools/
*	The hpricot gem (version 0.8.6): https://github.com/hpricot/hpricot
*	Ruby 1.9.3
*	Bundler 1.0.21

Installation
------------
To install Sword2Ruby and its associated dependencies, make sure you have Bundler installed, then from
the command line, run:

	bundle install sword2ruby

Now you can use the Sword2Ruby library with:

	require 'sword2ruby'
	
at the top of your Ruby code.

Usage
-----
Refer to the Rdoc for full details of all the classes and their methods.



====================================================

Sword2Client
------------

Set SWORD server username, password, service_doc_url and default_collection_url in config/sword.yml

require 'sword2_client'

sword = Sword2Client.new

This makes some convenience methods available to you:

  # make a new container in a collection by POSTing a file or metadata or both
  # URL expected to identify collection - should be collection IRI
  def new_container(collection_url,filepath=nil,metadata={},headers={})

  # POST content to an existing container
  # URL expected to identify container - should be container edit IRI
  def add_to_container(container_url,filepath=nil,headers={})

  # PUT new content to a container (replacing current content)
  # URL expected to identify container - should be container edit IRI
  def replace_container_content(container_url,filepath=nil,headers={})

  # PUT new metadata to a container (replacing current metadata)
  # URL expected to identify container - should be container edit IRI
  def replace_container_metadata(container_url,metadata={},headers={})

  # PUT new content and metadata to a container (replacing current content and metadata)
  # URL expected to identify container - should be container edit IRI
  def replace_container_content_and_metadata(container_url,filepath,metadata={},headers={})

  # DELETE content of a container
  # URL expected to identify container - should be container edit IRI
  def delete_container_content(container_url)

  # DELETE a container (and its content)
  # URL expected to identify container - should be container edit IRI
  def delete_container(container_url)

  # tell the sword server to change the  in-progress header of an item
  # URL expected to identify container - should be container edit IRI
  def set_in_progress(container_url,headers={"In-Progress"=>false})

These all call the execute method. Which you can call directly if you wish:

  # execute a method on collection, edit or edit-media
  def execute(method="get",on="collection",url=nil,filepath=nil,metadata={},headers={})

The execute method provides a response as defined by return_response(response,on,method)
* When HTTPSuccess,
  * get on collection will return a hash of the containers available
  * get on edit IRI will return a deposit receipt object
  * get on edit-media IRI will return the response body - a file
  * post will return the location of the container, and set a deposit receipt object
  * put or delete will return nil
* When HTTPError,
  * you will receive the error response

====================================================

About metadata
--------------

In order to pass metadata to a SWORD 2 server, an ATOM entry is created if necessary.
This is deemed necessary when metadata is passed in to the client.

The metadata must be a hash where the top keys are conformant ATOM.
Optionally you can include a key of "dc" pointing to a hash of Dublin Core terms.
This could be extended, but nothing else is supported for now. See SwordClient::AtomEntry

{
  "id":"SOME_ID",
  "updated":"DATE_UPDATED",
  "published":"PUBLISH_INFO",
   "title":"TITLE",
   "summary":"SUMMARY",
   "rights":"RIGHTS",
   "source":"SOURCE",
   "content":"CONTENT",
   "authors":[ "AUTHOR1", "AUTHOR2", ... ],
   "contributors":[ "CONTRIBUTOR1", "CONTRIBUTOR2", ... ],
   "links":[ "LINK1", "LINK2", ... ],
   "categories":[ "CAT1", "CAT2", ... ],
   "dc":{
            "VALID_DC_TERM":"VALUE",
            ...
        }
}

====================================================

About headers
-------------

  # authorisation headers should be provided from the sword.yml
  # On-Behalf-Of can be set there too
  # these headers are added in SwordClient::Connection.request for every action

  # User-Agent can be provided if so desired

  # In-Progress can be provided if so desired, set to true or false
  # Slug can be provided if so desired, should be a string representing the content

  # Metadata-Relevant can be provided if so desired for PUT operations of file content

  # Packaging header cannot be determined - must be provided if required
  # e.g. if the deposit object has a package format that should be communicated to the server
  # it will be assumed to be default http://purl.org/net/sword/package/Binary where appropriate

  # Accept-Packaging can be set for a GET on the edit-media IRI, to specify
  # which format is desired in response. The packaging formats the server supports are
  # detailed in the repo.servicedoc

  # FOLLOWING ARE NOTES ON WHAT SWORD SERVER EXPECTS
  # THESE ARE HANDLED WHERE NECESSARY BY THE CLIENT, BUT CAN BE OVERRIDDEN
  # (these are dealt with in SwordClient::DepositObject)

  # create by POST with binary content
  # MUST Content-Disposition
  # SHOULD Content-Type, Content-MD5, Packaging
  # MAY In-Progress (true/false), Slug

  # create by POST with multipart
  # combine a package (possibly a simple ZIP) - the Media Part
  # with a set of Dublin Core metadata terms [DublinCore] embedded in an Atom Entry - the Entry part.
  # MUST Content-Disposition - type attachment on Entry Part with a name param set to atom
  # MUST Content-Disposition - type attachment on the Media Part with name param set to payload and a filename parameter
  # SHOULD Content-MD5, Packaging - Media Part
  # SHOULD add Dublin Core [DublinCore] terms to the Atom Entry as foreign markup (if appropriate);
      # MUST be embedded as direct children of the atom:entry element, if present.
  # MAY In-Progress (true/false), On-Behalf-Of, Slug on main HTTP header
  # MAY add any other metadata formats or foreign markup to the atom:entry element


  # replace by PUT of new file content to EM-IRI
  # MUST Content-Disposition header with a filename parameter
  # SHOULD Content-Type, Content-MD5, Packaging
  # MAY On-Behalf-Of, Metadata-Relevant


  # replace by PUT of metadata and content to Edit-IRI (as per POST with multipart)
  # MUST Content-Disposition header of type attachment on Entry Part with a name parameter set to atom
  # MUST Content-Disposition header of type attachment on Media Part with a name parameter set to payload and a filename parameter
  # SHOULD Content-MD5, Packaging - Media Part
  # SHOULD add Dublin Core [DublinCore] terms to Atom Entry as foreign markup (if appropriate);
      # MUST be embedded as direct children of the atom:entry element, if present.
  # MAY In-Progress, On-Behalf-Of, Metadata-Relevant
  # MAY add any other metadata formats or foreign markup to the atom:entry element


  # replace by PUT of new metadata to Edit-IRI
  # SHOULD Content-Type header with the value application/atom+xml
  # MAY On-Behalf-Of, In-Progress

====================================================
