require 'atom/feed'

module Sword2Ruby
  
  #Extend existing Atom::Service with Sword methods
  class ::Atom::Feed < ::Atom::Element
    
    #This method returns an array of Atom::Categories of the original deposit (usually contained in the Sword Statement Atom Feed),
    #or an empty array [ ] if none are defined.
    #
    #For more information, see the Sword2 specification: {section 11.4. "Atom Serialisation"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_atom].
    def sword_state_categories
      Utility.find_elements_by_scheme(categories, "http://purl.org/net/sword/terms/state")
    end

    #This method returns the string href of the <sword:state> tag (usually contained in the Sword Statement Atom Feed),
    #or nil if it is not defined.
    #
    #For more information, see the Sword2 specification: {section 11.1.2. "sword:state"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_state].
    def sword_state
      Utility.find_element_attribute_value(extensions, "sword:state", "href")
    end

    #This method returns the string value of the <sword:stateDescription> tag (usually contained in the Sword Statement Atom Feed),
    #or nil if it is not defined.
    #
    #For more information, see the Sword2 specification: {section 11.1.7. "sword:state"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_description].
    def sword_state_description
      swordstate = Utility.find_element_by_name(extensions, "sword:state")
      swordstate.nil? ? nil : Utility.find_element_text(swordstate.elements, "sword:stateDescription")
    end
    
  end
end