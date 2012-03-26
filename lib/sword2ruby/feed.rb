#feed.rb

require 'atom/feed'

module Sword2Ruby
  
  #Extend existing Atom::Service with Sword methods
  class Atom::Feed < Atom::Element
    
    def sword_state_categories
      Utility.find_elements_by_scheme(categories, "http://purl.org/net/sword/terms/state")
    end
    
    def sword_state
      Utility.find_element_attribute_value(extensions, "sword:state", "href")
    end
    
    def sword_state_description
      swordstate = Utility.find_element_by_name(extensions, "sword:state")
      swordstate.nil? ? nil : Utility.find_element_text(swordstate.elements, "sword:stateDescription")
    end
    
  end
end