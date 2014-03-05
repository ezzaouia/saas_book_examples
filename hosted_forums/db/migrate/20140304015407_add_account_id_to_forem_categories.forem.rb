# This migration comes from forem (originally 20140304015336)
class AddAccountIdToForemCategories < ActiveRecord::Migration
  def change
    add_column :forem_categories, :account_id, :integer
  end
end
