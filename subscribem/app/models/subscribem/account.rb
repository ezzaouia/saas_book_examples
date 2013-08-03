module Subscribem
  class Account < ActiveRecord::Base
  	validates :subdomain, :presence => true, :uniqueness => true
  	belongs_to :owner, :class_name => "Subscribem::User"
  	accepts_nested_attributes_for :owner
    has_many :members, :class_name => "Subscribem::Member"
    has_many :users, :through => :members

    def self.create_with_owner(params={})
      account = new(params)
      if account.save
        account.users << account.owner
      end
      account
    end
  end
end
