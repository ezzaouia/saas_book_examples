# This migration comes from subscribem (originally 20131026081912)
class AddSubdomainToSubscribemAccounts < ActiveRecord::Migration
  def change
    add_column :subscribem_accounts, :subdomain, :string
  end
end
