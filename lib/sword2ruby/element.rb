require 'atom/element'

module Sword2Ruby
  #Extensions to the atom-tools[https://github.com/bct/atom-tools/wiki] Atom::Element class to support Sword2 operations.
  #These methods are additive to those supplied by the atom-tools gem.
  #
  #Please see the {atom-tools documentation}[http://rdoc.info/github/bct/atom-tools/master/frames] for a complete list of attributes and methods.
  class Atom::Element
    #Sword2Ruby::Connection (Atom::HTTP) object to facilitate connections in derived classes, such as Atom::Entry, Atom::Feed, Atom::Workspace and Atom::Collection.
    attr_accessor :http
  end
end