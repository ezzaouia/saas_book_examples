require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'forem/testing_support/factories/forums'

describe Forem::Admin::ForumsController do
  let!(:account_a) do 
    FactoryGirl.create(:account, :name => "Account A")
  end

  let!(:account_b) do
    FactoryGirl.create(:account, :name => "Account A")
  end

  let!(:user) { double('User') }

  before do
    controller.stub :user_signed_in? => true
    controller.stub :current_user => user
    controller.stub :forem_admin? => true
  end

  context "on Account A's subdomain" do
    before do
      @request.host = "#{account_a.subdomain}.example.com"
      controller.stub :current_account => account_a
    end

    let!(:forum_a) do
      FactoryGirl.create(:forum,
        :account_id => account_a.id)
    end
    let!(:forum_b) do
      FactoryGirl.create(:forum,
        :account_id => account_b.id)
    end

    context "index" do
      it "does not show Forum B on Account A's subdomain" do
        get :index, :use_route => :forem
        response.should be_success
        assigns[:forums].should_not(
          include(forum_b),
          "Expected categories to not contain Forum B, but it did."
        )
      end
    end

    context "create" do
      let(:category_a) do
        FactoryGirl.create(:category, :account_id => account_a.id)
      end

      let(:category_b) do
        FactoryGirl.create(:category, :account_id => account_b.id)
      end

      it "creates the forum within the scope of the current account" do
        post :create, :forum => {
          :title => "Forum A",
          :description => "A Forum",
          :category_id => category_a.id
        }, :use_route => :forem
        success_message = I18n.t("forem.admin.forum.created")
        expect(assigns[:forum].account_id).to eq(account_a.id)
        expect(flash[:notice]).to eq(success_message)
      end

      it "cannot create a forum with an invalid category" do
        post :create, :forum => {
          :title => "Forum A",
          :description => "A Forum",
          :category_id => category_b.id
        }, :use_route => :forem
        error_message = "Invalid category selected."
        expect(flash.now[:alert]).to eq(error_message)
      end
    end

    context "update" do
      it "can update a forum belonging to the current account" do
        put :update, :id => forum_a.id,
          :forum => {
            :title => "Forum A"
          }, :use_route => :forem
        success_message = "That forum has been updated."
        expect(flash[:notice]).to eq(success_message)
      end

      it "cannot update a forum belonging to another account" do
        expect do
          put :update, :id => forum_b.id,
            :forum => {
              :title => "Forum B"
            }, :use_route => :forem
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "destroy" do
      it "can destroy a forum belonging to the current account" do
        delete :destroy, :id => forum_a.id, :use_route => :forem
        success_message = "The selected forum has been deleted."
        expect(flash[:notice]).to eq(success_message)
      end

      it "cannot update a forum belonging to another account" do
        expect do
          delete :destroy, :id => forum_b.id, :use_route => :forem
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end