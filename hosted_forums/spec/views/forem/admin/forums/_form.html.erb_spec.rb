require "spec_helper"
require 'subscribem/testing_support/factories/account_factory'
require 'forem/testing_support/factories/categories'

describe "forem/admin/forums/_form.html.erb" do
  let!(:account_a) do 
    FactoryGirl.create(:account, :name => "Account A")
  end

  let!(:account_b) do
    FactoryGirl.create(:account, :name => "Account A")
  end

  let!(:category_a) do
    FactoryGirl.create(:category,
      :name => "Category A",
      :account_id => account_a.id)
  end
  
  let!(:category_b) do
    FactoryGirl.create(:category,
      :name => "Category B",
      :account_id => account_b.id)
  end

  before do
    view.stub current_account: account_a
    assign :forum, Forem::Forum.new
  end

  it "displays only the categories from the current account" do
    render
    html = Nokogiri::HTML::DocumentFragment.parse(rendered)
    categories = html.css("#forum_category_id option").map(&:text)
    expect(categories).to include(category_a.name)
    expect(categories).to_not include(category_b.name)
  end
end