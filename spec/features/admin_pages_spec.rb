require 'rails_helper'

RSpec.feature "AdminPages", type: :feature do
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
end
