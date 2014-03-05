require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'subscribem/testing_support/factories/user_factory'
require 'subscribem/testing_support/authentication_helpers'

feature "Forum scoping" do
  include Subscribem::TestingSupport::AuthenticationHelpers
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  def create_forum(account, name)
    scoped_categories = Forem::Category.scoped_to(account)
    category = scoped_categories.create(:name => "A category")
    forum = Forem::Forum.scoped_to(account).new
    forum.name = name
    forum.description = "A forum"
    forum.category = category
    forum.tap(&:save!)
    forum
  end

  let!(:forum_a) do
    create_forum(account_a, "Account A's Forum")
  end

  let!(:forum_b) do
    create_forum(account_b, "Account B's Forum")
  end

  scenario "displays only account A's forums" do
    sign_in_as(:user => account_a.owner, :account => account_a)
    visit "http://#{account_a.subdomain}.example.com/forums"
    page.should have_content("Account A's Forum")
    page.should_not have_content("Account B's Forum")
  end

  scenario "display only account B's forums" do
    sign_in_as(:user => account_b.owner, :account => account_b)
    visit "http://#{account_b.subdomain}.example.com/forums"
    page.should have_content("Account B's Forum")
    page.should_not have_content("Account A's Forum")
  end

  scenario "Account A's forums are visible on Account A's subdomain" do
    sign_in_as(:user => account_a.owner, :account => account_a)
    visit forem.forum_url(forum_a, subdomain: account_a.subdomain)
    page.status_code.should == 200
  end

  scenario "Account B's forums are inaccessible Account A's subdomain" do
    sign_in_as(:user => account_a.owner, :account => account_a)
    expect do
      visit forem.forum_url(forum_b, subdomain: account_a.subdomain)
    end.to raise_error(ActiveRecord::RecordNotFound)
  end
end
