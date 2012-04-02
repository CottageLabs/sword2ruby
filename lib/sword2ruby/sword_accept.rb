module Sword2Ruby
  
  #This class overrides the Atom <app:accept> class and ensures that the "alternate" attribute
  #is preserved in the tag, required for processing Sword documents.
  class SwordAccept < Atom::Text
    is_element ATOM_PUBLISHING_PROTOCOL_NAMESPACE, :accept
    attrb ATOM_PUBLISHING_PROTOCOL_NAMESPACE, :alternate
  end

end