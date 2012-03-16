#entry.rb

require 'atom/entry'

module Sword2Ruby
  class Atom::Entry < Atom::Element
    
    def alternate_uri
      Utility.find_link_uri(links, "alternate")
    end
    
    def media_entry_uri
      Utility.find_link_uri(links, "edit")
    end

    def media_resource_links
      Utility.find_links_all_types(links, "edit-media")
    end

    def sword_edit_uri
      Utility.find_link_uri(links, "http://purl.org/net/sword/terms/add")
    end    
    
    def sword_original_deposit_uri
      Utility.find_link_uri(links, "http://purl.org/net/sword/terms/originalDeposit")
    end

    def sword_derived_resource_links
      Utility.find_links_all_types(links, "http://purl.org/net/sword/terms/derivedResource")
    end
   
    def sword_statement_links
      Utility.find_links_all_types(links, "http://purl.org/net/sword/terms/statement")
    end
    
    def sword_accept_packagings
      Utility.find_extensions_string(extensions, "sword:packaging")
    end
    
    def sword_treatment
      Utility.find_extension_string(extensions, "sword:treatment")
    end
    
    def sword_verbose_description
      Utility.find_extension_string(extensions, "sword:verboseDescription")
    end
    
    def dublin_core_extensions
      Utility.find_extensions_by_namespace(extensions, "http://purl.org/dc/terms/")

    end
     
  end
end