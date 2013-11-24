require 'spec_helper'

feature "User signup" do
  let!(:account) { FactoryGirl.create(:account_with_schema) }
  let(:subdomain_root) { "http://#{account.subdomain}.example.com/" }

  scenario "under an account" do
    visit subdomain_root
    page.current_url.should == subdomain_root + "sign_in" 
    click_link "New User?"
    fill_in "Email", :with => "user@example.com"
    fill_in "Password", :with => "password"
    fill_in "Password confirmation", :with => "password"
    click_button "Sign up"
    page.should have_content("You have signed up successfully.")
    page.current_url.should == subdomain_root
  end
end