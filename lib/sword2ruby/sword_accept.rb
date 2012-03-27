module Sword2Ruby
  
  #Special class to override the usual <app:accept> class
  class SwordAccept < Atom::Text
    is_element ATOM_PUBLISHING_PROTOCOL_NAMESPACE, :accept
    attrb ATOM_PUBLISHING_PROTOCOL_NAMESPACE, :alternate
  end

end