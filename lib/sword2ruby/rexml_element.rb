require 'rexml/element'

module Sword2Ruby

  #Overloads for the rdf:Description tag (REXML::Element), used for describing OAI-ORE Sword Statements.
  #
  #For more information, see the Sword2 specification: {section 11.3. "OAI-ORE Serialisation"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_oaiore].
  class  REXML::Element

     #This method returns the string value of the @rdf:about attribute for the <rdf:Description> element (i.e. for each element in the Sword2Ruby::SwordStatementOAIORE#rdf_descriptions array, usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.3. "OAI-ORE Serialisation"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_oaiore].
     def rdf_about
       self.attributes["rdf:about"]
     end

     #This method returns the string value of the @rdf:resource attribute for the <sword:originalDepsit> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.1. "sword:originalDeposit"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_originaldeposit].
     def sword_original_deposit
       Utility.find_element_attribute_value(self.elements, "sword:originalDeposit", "rdf:resource")
     end
     
     #This method returns the string value of the @rdf:resource attribute of the <sword:state> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.2. "sword:state"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_state].
     def sword_state
       Utility.find_element_attribute_value(self.elements, "sword:state", "rdf:resource")
     end

     
     
     #This method returns an array of the string values of the @rdf:resource attribute for the <sword:packaging> tags (usually contained in the OAI-ORE Sword Statement),
     #or an empty array [ ] if none are defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.3. "sword:packaging"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_packaging].
     def sword_packagings
       Utility.find_elements_attribute_value(self.elements, "sword:packaging", "rdf:resource")
     end

     #This method returns the Time value of the <sword:depositedOn> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.4. "sword:depositedOn"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_depositedon].
     def sword_deposited_on
       Utility.find_element_time(self.elements, "sword:depositedOn")
     end
     
     #This method returns the string value of the <sword:depositedBy> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.5. "sword:depositedBy"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_depositedby].
     def sword_deposited_by
       Utility.find_element_text(self.elements, "sword:depositedBy")
     end

     #This method returns the string value of the <sword:depositedOnBehalfOf> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.6. "sword:depositedOnBehalfOf"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_obo].
     def sword_deposited_on_behalf_of
       Utility.find_element_text(self.elements, "sword:depositedOnBehalfOf")
     end


     #This method returns the string value of the <sword:stateDescription> tag (usually contained in the OAI-ORE Sword Statement),
     #or nil if it is not defined.
     #
     #For more information, see the Sword2 specification: {section 11.1.7. "sword:stateDescription"}[http://sword-app.svn.sourceforge.net/viewvc/sword-app/spec/tags/sword-2.0/SWORDProfile.html?revision=377#statement_predicates_description].
     def sword_state_description
       Utility.find_element_text(self.elements, "sword:stateDescription")
     end


  end
end