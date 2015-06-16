require 'rails_helper'

RSpec.feature "User Pages", type: :feature do
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
        it { should have_link("Profile", href: user_path(user)) }
        it { should_not have_link("Log in", href: login_path) }
        it { should_not have_link("Register", href: register_path) }
        it "should redirect to user page" do
          expect(current_url).to eq(user_url(user))
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    it { should have_selector('h1', text: user.username) }
    it { should have_title(user.username) }
    it { should_not have_link('Edit all', href: edit_user_path(user)) }
    describe "after login" do
      let(:password) { FactoryGirl.build(:user).password }
      before do
        capybara_login user.email, password
        visit user_path(user)
      end
      it { should have_link('Edit all', href: edit_user_path(user)) }
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.build(:user) }
    let!(:password) { user.password }
    before do
      user.save
      capybara_login(user.email, password)
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_title('Edit profile') }
      it { should have_selector('h1', text: 'Edit profile') }
    end

    describe "with invalid current password" do
      before { click_button "Save Changes" }

      it { should have_error_message('Current password') }
    end

    describe "with invalid information" do
      before do
        fill_in "Current Password", with: password
        click_button "Save Changes"
      end

      it { should_not have_error_message('Current Password') }
      it { should have_content('error') }
    end
    describe "with valid information" do
      let(:new_email) { "hoge@example.com" }
      let(:new_username) { "test" }
      let(:new_password) { "new_secure-password!" }
      before do
        fill_in "Username", with: new_username
        fill_in "Email", with: new_email
        fill_in "Password", with: new_password
        fill_in "Password Confirmation", with: new_password
        fill_in "Current Password", with: password
        click_button "Save Changes"
      end

      it { should have_title(new_username) }
      it { should have_success_message('Profile') }
      it "username of user should be modified" do
        expect(user.reload.username).to eq new_username
      end
      it "email of user should be modified" do
        expect(user.reload.email).to eq new_email
      end
      it "password of user should be modified" do
        expect(user.reload.correct_password? new_password).to be true
      end
    end
  end
end
