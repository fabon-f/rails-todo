require 'rails_helper'

RSpec.feature "AdminPages", type: :feature do
  shared_context 'as admin user' do
    let(:admin) { FactoryGirl.build(:admin) }
    let!(:password) { admin.password }
    before do
      admin.save
      capybara_login(admin.email, password)
    end
  end

  describe "visit without login" do
    before { visit admin_root_path }
    it "should redirect to root" do
      expect(current_url).to eq root_url
    end
  end

  describe "visit as normal user" do
    let(:user) { FactoryGirl.build(:user) }
    let!(:password) { user.password }
    before do
      user.save
      capybara_login(user.email, password)
      visit admin_root_path
    end
    it "should redirect to root" do
      expect(current_url).to eq root_url
    end
  end

  describe "root page" do
    include_context "as admin user" do
      before { visit admin_root_path }
    end
    it { should have_title 'Admin page' }
  end
end
