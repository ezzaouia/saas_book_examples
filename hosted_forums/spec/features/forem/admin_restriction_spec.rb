require "spec_helper"
require "subscribem/testing_support/factories/account_factory"
require "subscribem/testing_support/authentication_helpers"

feature "Forum scoping" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    settings = account_a.settings_for(account_a.owner)
    settings.set(:forem_admin, true)

    account_b.users << account_a.owner

    visit "http://#{account_a.subdomain}.example.com/sign_in"
    fill_in "Email", :with => account_a.owner.email
    fill_in "Password", :with => "password"
    click_button "Sign in"
  end

  scenario "is only the forum admin for one account" do
    visit "http://#{account_a.subdomain}.example.com/forums"

    page.should have_content("Admin Area")

    visit "http://#{account_b.subdomain}.example.com/forums"
    binding.pry
    page.should_not have_content("Please sign in.")
    page.should_not have_content("Admin Area")
  end
end