require 'sword2ruby';

#:nodoc:
#These are constants used by the unit tests
TEST_USERNAME_VALID = 'sword'
TEST_PASSWORD_VALID = 'sword'
TEST_USERNAME_INVALID = 'invalid-username'
TEST_PASSWORD_INVALID = 'invalid-password'

TEST_USER_VALID = Sword2Ruby::User.new(TEST_USERNAME_VALID, TEST_PASSWORD_VALID);
TEST_CONNECTION_VALID = Sword2Ruby::Connection.new(TEST_USER_VALID);
TEST_USER_INVALID = Sword2Ruby::User.new(TEST_USERNAME_INVALID, TEST_PASSWORD_INVALID);
TEST_CONNECTION_INVALID = Sword2Ruby::Connection.new(TEST_USER_INVALID);

TEST_SERVICE_DOCUMENT_URI_VALID = 'http://localhost:8080/sd-uri'
TEST_SERVICE_DOCUMENT_URI_INVALID_PROTOCOL = 'ftp://localhost:8080/service-doc'
TEST_SERVICE_DOCUMENT_URI_MALFORMED = 'http: this is wrong';

TEST_SWORD_VERSION = '2.0'
TEST_REPOSITORY_NAME = 'Main Site'
TEST_COLLECTION_COUNT = 10


TEST_COLLECTION_HREF = 'http://localhost:8080/col-uri/067cadb4-fad2-4be6-8f04-a5f5997a7399'
