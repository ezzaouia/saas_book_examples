require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'subscribem/testing_support/factories/user_factory'
require 'subscribem/testing_support/authentication_helpers'

feature "Category scoping" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  def create_category(account, name)
    scoped_categories = Forem::Category.scoped_to(account)
    scoped_categories.create(:name => name)
  end

  let(:category_a) do
    create_category(account_a, "Account A's Category")
  end

  let(:category_b) do
    create_category(account_b, "Account B's Category")
  end

  scenario "can see account A's category" do
    category = category_a
    subdomain = account_a.subdomain

    sign_in_as(:user => account_a.owner, :account => account_a)
    visit forem.category_url(category, subdomain: subdomain)
    page.status_code.should == 200
  end

  scenario "cannot see Account B's category" do
    category = category_b
    subdomain = account_a.subdomain

    sign_in_as(:user => account_a.owner, :account => account_a) 
    expect do
      visit forem.category_url(category, subdomain: subdomain)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end  
end