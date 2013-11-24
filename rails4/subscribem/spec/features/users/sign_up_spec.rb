require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'

feature "User signup" do
  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:root_url) { "http://#{account.subdomain}.example.com/" }

  scenario "under an account" do
    visit root_url
    page.current_url.should == root_url + "sign_in" 
    click_link "New User?"
    fill_in "Email", :with => "user@example.com"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Sign up"
    page.should have_content("You have signed up successfully.")
    page.current_url.should == root_url
  end
end