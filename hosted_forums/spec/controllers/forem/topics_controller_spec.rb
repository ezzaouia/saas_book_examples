require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'subscribem/testing_support/factories/user_factory'
require 'forem/testing_support/factories/forums'
require 'forem/testing_support/factories/topics'

describe Forem::TopicsController do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  before do
    controller.stub :user_signed_in? => true
    controller.stub :current_user => FactoryGirl.create(:user)
    controller.stub :ensure_moderator_or_admin => true
  end

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

  let!(:topic_a) do
    FactoryGirl.create(:topic,
                       :forum => forum_a,
                       :user => controller.current_user)
  end

  let!(:topic_b) do
    FactoryGirl.create(:topic,
                       :forum => forum_b,
                       :user => controller.current_user)
  end

  context "from Account A's subdomain" do
    before do
      @request.host = "#{account_a.subdomain}.example.com"
      controller.stub :current_account => account_a
    end

    it "can view a topic in a forum for this account" do
      get :show, :forum_id => forum_a.id,
                 :id => topic_a.id,
                 :use_route => :forem
      response.status.should == 200
    end

    it "cannot view a topic belonging to a different account" do
      expect do
        get :show, :forum_id => forum_b.id,
                   :id => topic_a.id,
                   :use_route => :forem
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end