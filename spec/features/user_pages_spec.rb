require 'rails_helper'

RSpec.describe "User Pages", type: :feature do
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

      describe "after submission" do
        before { click_button submit }

        it { should have_title('Register') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "HogeFuga"
        fill_in "Password Confirmation", with: "HogeFuga"
        fill_in "Username", with: "example_user"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_selector('div.alert-box.radius.success', text: 'Welcome') }
        it { should have_link("Log out", href: logout_path) }
        it { should have_link("Profile", href: user_path(user.username)) }
        it { should_not have_link("Log in", href: login_path) }
        it { should_not have_link("Register", href: register_path) }
        it "should redirect to user page" do
          expect(current_url).to eq(user_url(user.username))
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user.username) }
    it { should have_selector('h1', text: user.username) }
    it { should have_title(user.username) }
  end
end
