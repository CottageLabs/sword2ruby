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

