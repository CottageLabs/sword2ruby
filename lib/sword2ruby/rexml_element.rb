#rdf_description.rb

require 'rexml/element'

module Sword2Ruby

  #Overloads for rdf:Description (REXML::Element), used for describing OAI-ORE Sword Statements.
  class  REXML::Element

     #This method returns the string value of the @rdf:about attribute (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: <MISSING>.
     def rdf_about
       self.attributes["rdf:about"]
     end

     #This method returns the string value of the XXXX attribute (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: <MISSING>.
     def sword_packagings
       Utility.find_elements_attribute_value(self.elements, "sword:packaging", "rdf:resource")
     end

     #This method returns the string value of the XXXX attribute (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: <MISSING>.
     def sword_original_deposit
       Utility.find_element_attribute_value(self.elements, "sword:originalDeposit", "rdf:resource")
     end

     #This method returns the string value of the <sword:depositedOn> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     def sword_deposited_on
       Utility.find_element_time(self.elements, "sword:depositedOn")
     end
     
     #This method returns the string value of the <sword:depositedBy> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     def sword_deposited_by
       Utility.find_element_text(self.elements, "sword:depositedBy")
     end

     #This method returns the string value of the <sword:depositedOnBehalfOf> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     def sword_deposited_on_behalf_of
       Utility.find_element_text(self.elements, "sword:depositedOnBehalfOf")
     end

     #This method returns the string value of the @rdf:about attribute (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.2. "sword:state"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_state].     
     def sword_state
       Utility.find_element_attribute_value(self.elements, "sword:state", "rdf:resource")
     end

     #This method returns the string value of the <sword:stateDescription> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.7. "sword:state"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_description].
     def sword_state_description
       Utility.find_element_text(self.elements, "sword:stateDescription")
     end

  end
end