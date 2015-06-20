require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  subject { page }

  describe "for user not logged in" do
    before { visit root_path }
    it { should have_link 'Log in', href: login_path }
    it { should have_link 'Register', href: register_path }
    it { should_not have_link('Log out', href: logout_path) }
    it { should_not have_link('Profile') }
    it { should_not have_link('Admin page', href: admin_root_path) }
  end

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
        capybara_login(user.email.upcase, password, visit_login_path: false)
      end

      it { should have_link('Log out', href: logout_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should_not have_link('Log in', href: login_path) }
      it { should_not have_link('Register', href: register_path) }
      it { should_not have_link('Admin page', href: admin_root_path) }
      it "should redirect to user page" do
        expect(current_url).to eq(user_url(user))
      end

      describe "after visiting login page" do
        before { visit login_path }
        it { should have_notice_message('You are already logged in') }
      end

      describe "followed by logout" do
        before { click_link "Log out" }
        it { should have_success_message('Logged out') }
        it { should have_link('Log in') }
        it { should have_link('Register') }
        it { should_not have_link('Log out') }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.build :admin }
      before do
        password = admin.password
        admin.save
        capybara_login admin.email, password, visit_login_path: false
      end
      it { should have_link 'Admin page', href: admin_root_path }
    end
  end
end
