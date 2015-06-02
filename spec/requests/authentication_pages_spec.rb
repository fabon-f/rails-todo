require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  subject { page }
  describe "login page" do
    before { visit login_path }

    it { should have_content('Log in') }
    it { should have_title('Log in') }
    it { should have_link('Register Now', register_path) }
  end

  describe "login" do
    before { visit login_path }

    describe "with invalid information" do
      before { click_button "Log in" }
      it { should have_title('Log in') }
      it { should have_error_message('Invalid') }
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.build(:user) }
      before do
        password = user.password
        user.save
        capybara_login(user.email.upcase, password)
      end

      it { should have_link('Log out', href: logout_path) }
      it { should_not have_link('Log in', href: login_path) }

      describe "after visiting login page" do
        before { visit login_path }
        it { should have_notice_message('You are already logged in') }
      end

      describe "followed by logout" do
        before { click_link "Log out" }
        it { should have_link('Log in') }
        it { should have_link('Register') }
        it { should_not have_link('Log out') }
      end
    end
  end
end
