require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  subject { page }

  describe "Home page" do
    before { visit root_path }
    it { should have_content('Home') }
    it { should have_title('Home') }
  end

  describe "Help page" do
    before { visit help_path }
    it { should have_content('Help') }
    it { should have_title('Help') }
  end
end
