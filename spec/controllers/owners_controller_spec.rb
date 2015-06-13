require 'spec_helper'

describe OwnersController do

  before :all do
    @owner = Owner.create!(name: "Brett Simpson", email: 'foo@bar.com', password: '12345678')
  end
  after :all do
    Restaurant.destroy_all
    Owner.destroy_all
  end

  context "signed in as owner" do
    before { sign_in @owner }

    it "displays to dashboard" do
      get :dashboard

      expect(response).to be_success
    end
  end

  context "not signed in as owner" do
    it "redirects to restaurants index" do
      get :dashboard

      response.should redirect_to restaurants_path
    end
  end
end
