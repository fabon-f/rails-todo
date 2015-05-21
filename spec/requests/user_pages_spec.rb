require 'rails_helper'

RSpec.describe "User Pages", type: :request do
  subject { page }
  describe "register page" do
    before { visit register_path }
    it { should have_content('Register') }
    it { should have_title('Register') }
  end

  describe "register" do
    before { visit register_path }
    let(:submit) { "Register" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "HogeFuga"
        fill_in "Password Confirmation", with: "HogeFuga"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
