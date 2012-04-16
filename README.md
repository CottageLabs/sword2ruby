Sword2Ruby gem
==================

Introduction
------------
The Sword2Ruby gem provides Sword client functionality when run against a Sword 2.0 compliant server.
It eases integration of Ruby applications with Sword servers, taking care of things like authentication,
deposit-receipts and the parsing of Sword tags.

It was developed as part of the JISC Sword 2.0 project. For more information on Sword, see:
http://www.swordapp.org/. The Sword 2 specification can be found at: 
http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377

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
To install Sword2Ruby and its associated dependencies, make sure you have Bundler installed (gem install bundler).
Then update your project's Gemfile to include a reference to Sword2Ruby:

	gem 'sword2ruby'
	
Then, on the command line inside your project folder, run to install all necessary gems:

	bundle install

Finally, ensure you require a reference to the gem in your code:

	require 'sword2ruby'


Usage
-----
Refer to the Rdoc for full details of all the classes and their methods:
http://www.rubydoc.info/github/CottageLabs/sword2ruby/master/frames


Example Walkthrough
-------------------
Make sure you have Ruby 1.9.3 (or perhaps later) running, and then run irb to enter the Ruby command line:

	$ ruby -v
	ruby 1.9.3p0 (2011-10-30 revision 33570) [x86_64-darwin11.2.0]
	$ irb

Now try and run the following statements to post a file to Sword and then update its title:-

	#Example Sword2Ruby walkthrough

	#Require the Sword2Ruby library
	require 'Sword2Ruby'

	#Print out the version number
	puts "Running Sword2Ruby version #{Sword2Ruby::Version}"

	#Define the authentication credentials for the connection
	sword_user = Sword2Ruby::User.new('sword', 'sword')

	#Define the connection object using the username and password
	connection = Sword2Ruby::Connection.new(sword_user)

	#Get the Service Document
	service = Atom::Service.new('http://localhost:8080/sd-uri', connection)

	#Print out some properties for the Service
	puts "service.sword_version: #{service.sword_version}"
	puts "service.sword_max_upload_size: #{service.sword_max_upload_size}"
	puts "service.workspaces.count: #{service.workspaces.count}"
	puts "service.collections.count: #{service.collections.count}"

	#Get a collection
	collection = service.collections.last

	#Post a file to the collection
	deposit_receipt = collection.post_media!(:filepath=>"test.txt", :content_type=>"text/plain")

	#Print out the deposit receipt
	puts "deposit_receipt.has_entry: #{deposit_receipt.has_entry}"
	puts "deposit_receipt.entry.to_s: #{deposit_receipt.entry.to_s}"

	#Update the title using the Deposit Receipt's title
	deposit_receipt.entry.title = "New Title"
	deposit_receipt.entry.put!

	#Print out the URL to the webpage for the item
	puts "deposit_receipt.entry.alternate_uri: #{deposit_receipt.entry.alternate_uri}"

