#deposit_receipt.rb

require 'atom/entry'

module Atom
  class OldDepositReceipt < Atom::Entry
    atom_elements :author, :authors, Atom::Author
    include HasLinks
  end
end