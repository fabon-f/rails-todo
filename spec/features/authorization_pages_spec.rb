require 'rails_helper'

RSpec.feature "Authorizations", type: :feature do
  subject { page }
  describe "for user not logged in" do
    let(:user) { FactoryGirl.build(:user) }
    let!(:password) { user.password }
    before do
      user.save
    end

    describe "visiting edit page" do
      before { visit edit_user_path(user) }
      it { should have_title('Log in') }
      it { should have_notice_message('Please log in first') }
    end

    describe "patch request to update action" do
      before { page.driver.submit :patch, user_path(user), {} }
      it { should have_title 'Log in' }
      it { should have_notice_message 'Please log in first' }
    end

    describe "when attempting to visit a protected page" do
      before do
        visit edit_user_path(user)
        capybara_login user.email, password, visit_login_path: false
      end
      describe "after login" do
        it "should redirect to desired protected page" do
          expect(current_url).to eq edit_user_url(user)
        end
      end
    end
  end

  describe "as wrong user" do
    let(:another_user) { FactoryGirl.create(:user, email: "another@example.com", username: 'wrong') }
    let(:user) { FactoryGirl.build(:user) }
    before do
      password = user.password
      user.save
      capybara_login user.email, password
    end
    describe "visit edit page" do
      before { visit edit_user_path(another_user) }
      it "should redirect to root" do
        expect(current_url).to eq(root_url)
      end
    end

    describe "patch request to update action" do
      before { page.driver.submit :patch, user_path(another_user), {} }
      it "should redirect to root" do
        expect(current_url).to eq(root_url)
      end
    end
  end
end
