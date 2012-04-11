require 'sword2ruby';

#:nodoc:

#These are constants used by the unit tests

#CHANGE THESE VALUES TO MATCH YOUR TEST SERVER!
#In order to run the tests, make sure you update the URLs, usernames and passwords to match you setup
TEST_USERNAME_VALID = 'sword'
TEST_PASSWORD_VALID = 'sword'
TEST_AUTODISCOVER_SERVICE_HTML_URI = 'http://localhost:8080/'
TEST_AUTODISCOVER_COLLECTION_HTML_URI = 'http://localhost:8080/html/067cadb4-fad2-4be6-8f04-a5f5997a7399'
TEST_AUTODISCOVER_ENTRY_HTML_URI = 'http://localhost:8080/html/067cadb4-fad2-4be6-8f04-a5f5997a7399/sword2ruby_test_2012-04-04T11-16-11'
TEST_SERVICE_DOCUMENT_URI_VALID = 'http://localhost:8080/sd-uri'
TEST_COLLECTION_HREF = 'http://localhost:8080/col-uri/067cadb4-fad2-4be6-8f04-a5f5997a7399'
TEST_ATOM_STATEMENT_URI = "http://localhost:8080/state-uri/067cadb4-fad2-4be6-8f04-a5f5997a7399/sword2ruby_test_2012-04-09T19-22-45.atom"
TEST_RDF_STATEMENT_URI = "http://localhost:8080/state-uri/067cadb4-fad2-4be6-8f04-a5f5997a7399/sword2ruby_test_2012-04-09T19-22-45.rdf"

#------------------------------------------------
#No need to set anything from here onwards
TEST_USERNAME_INVALID = 'invalid-username'
TEST_PASSWORD_INVALID = 'invalid-password'

TEST_SERVICE_DOCUMENT_URI_INVALID_PROTOCOL = 'ftp://localhost:8080/service-doc'
TEST_SERVICE_DOCUMENT_URI_MALFORMED = 'http: this is wrong';

TEST_USER_VALID = Sword2Ruby::User.new(TEST_USERNAME_VALID, TEST_PASSWORD_VALID);
TEST_CONNECTION_VALID = Sword2Ruby::Connection.new(TEST_USER_VALID);
TEST_USER_INVALID = Sword2Ruby::User.new(TEST_USERNAME_INVALID, TEST_PASSWORD_INVALID);
TEST_CONNECTION_INVALID = Sword2Ruby::Connection.new(TEST_USER_INVALID);

TEST_SWORD_VERSION = '2.0'