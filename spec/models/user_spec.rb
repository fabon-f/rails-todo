require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = User.new(email: "user@example.com", password: 'foobarbaz', password_confirmation: 'foobarbaz', username: 'example')
  end

  subject { @user }
  it { should be_valid }

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before do
      @user.password = 'foo'
      @user.password_confirmation = 'foo'
    end
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = ' ' * 10 }
    it { should_not be_valid }
  end

  describe "when password is different to password confirmation" do
    before { @user.password = 'hogefuga' }
    it { should_not be_valid }
  end

  describe "when email is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email has big letters" do
    before do
      @user.email = "UseR@ExAMple.Com"
      @user.save
    end
    it "email should equal to downcase" do
      expect(@user.reload.email).to eq("user@example.com")
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = User.new(email: "USER@examPLe.com", password: 'hogefuga', password_confirmation: 'hogefuga', username: 'example2')
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when username is invalid" do
    it "should be invalid" do
      usernames = %w[hoge-fuga hoge! hoge& fuga)]
      usernames.each do |invalid_username|
        @user.username = invalid_username
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when username is valid" do
    it "should be valid" do
      usernames = %w[hoge fuga hoge2 __fu__g_]
      usernames.each do |valid_username|
        @user.username = valid_username
        expect(@user).to be_valid
      end
    end
  end

  describe "when username has big letters" do
    before do
      @user.username = "EXamplE_User"
      @user.save
    end
    it "username should equal to downcase" do
      expect(@user.reload.username).to eq("example_user")
    end
  end

  describe "when username is already taken" do
    before do
      user_with_same_username = User.new(email: "user2@example.com", password: 'foobarbaz', password_confirmation: 'foobarbaz', username: 'ExaMplE')
      user_with_same_username.save
    end
    it { should_not be_valid }
  end

  describe "correct_password? method" do
    before { @user.save }
    describe "when password is correct" do
      it "should return true" do
        expect(@user.correct_password? 'foobarbaz').to be true
      end
    end

    describe "when password is incorrect" do
      it "should return false" do
        expect(@user.correct_password? 'hogefuga').to be false
      end
    end
  end

  describe "when role is valid" do
    it "should be valid" do
      valid_roles = %w[user admin]
      valid_roles.each do |role|
        @user.role = role
        expect(@user).to be_valid
      end
    end
  end

  describe "when role is invalid" do
    it "should be invalid" do
      @user.role = 'hoge'
      expect(@user).not_to be_valid
    end
  end

  it { should respond_to :admin? }
  it "admin? method should return false" do
    expect(subject.admin?).to be false
  end

  describe "admin user" do
    let(:admin) { FactoryGirl.create(:admin) }
    it "admin? method should return true" do
      expect(admin.admin?).to be true
    end
  end

  describe "task association" do
    before { @user.save }
    let!(:task) { FactoryGirl.create(:task, user: @user) }
    it { should respond_to :tasks }
    it "should have tasks" do
      expect(@user.tasks.to_a).to eq [task]
    end

    it "should destroy associated tasks" do
      tasks = @user.tasks.to_a
      @user.destroy
      expect(tasks).not_to be_empty
      tasks.each do |task|
        expect(Task.where(id: task.id)).to be_empty
      end
    end
  end
end
