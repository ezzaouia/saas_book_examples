require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'forem/testing_support/factories/categories'
require 'forem/testing_support/factories/forums'

describe Forem::ModerationController do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  let!(:forum_a) do
    FactoryGirl.create(:forum, 
      :name => "Account A's Forum",
      :account_id => account_a.id)
  end

  let!(:forum_b) do
    FactoryGirl.create(:forum, 
      :name => "Account B's Forum",
      :account_id => account_b.id)
  end

  before do
    controller.stub :user_signed_in? => true
    controller.stub :current_user => double('User')
    controller.stub :ensure_moderator_or_admin => true
  end

  context "from Account A's subdomain" do
    before do
      @request.host = "#{account_a.subdomain}.example.com"
      controller.stub :current_account => account_a
    end

    it "can access Account A's forum tools" do
      get :index, :forum_id => forum_a.id, :use_route => :forem
      response.status.should == 200
    end

    it "cannot access Account B's forum tools" do
      expect do
        get :index, :forum_id => forum_b.id, :use_route => :forem
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end