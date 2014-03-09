require 'spec_helper'
require 'subscribem/testing_support/factories/account_factory'
require 'forem/testing_support/factories/categories'

describe Forem::Admin::CategoriesController do
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

    let!(:category_a) do
      FactoryGirl.create(:category,
        :account_id => account_a.id)
    end
    let!(:category_b) do
      FactoryGirl.create(:category,
        :account_id => account_b.id)
    end

    context "index" do
      it "does not show category b on Account A's subdomain" do
        get :index, :use_route => :forem
        response.should be_success
        assigns[:categories].should_not(
          include(category_b),
          "Expected categories to not contain Category B, but it did."
        )
      end
    end

    context "create" do
      it "creates the category within the scope of the current account" do
        post :create, :category => {
          :name => "Category A"
        }, :use_route => :forem
        expect(assigns[:category].account_id).to eq(account_a.id)
      end
    end

    context "update" do
      it "can update a category belonging to the current account" do
        put :update, :id => category_a.id,
          :category => {
            :name => "Category A"
          }, :use_route => :forem
        success_message = "That forum category has been updated."
        expect(flash[:notice]).to eq(success_message)
      end

      it "cannot update a category belonging to another account" do
        expect do
          put :update, :id => category_b.id,
            :category => {
              :name => "Category B"
            }, :use_route => :forem
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "destroy" do
      it "can destroy a category belonging to the current account" do
        delete :destroy, :id => category_a.id, :use_route => :forem
        success_message = "The selected forum category has been deleted."
        expect(flash[:notice]).to eq(success_message)
      end

      it "cannot update a category belonging to another account" do
        expect do
          delete :destroy, :id => category_b.id, :use_route => :forem
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end