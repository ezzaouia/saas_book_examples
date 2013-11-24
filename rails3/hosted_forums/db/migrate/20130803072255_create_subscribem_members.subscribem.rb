# This migration comes from subscribem (originally 20130803023919)
class CreateSubscribemMembers < ActiveRecord::Migration
  def change
    create_table :subscribem_members do |t|
      t.integer :account_id
      t.integer :user_id

      t.timestamps
    end
  end
end
