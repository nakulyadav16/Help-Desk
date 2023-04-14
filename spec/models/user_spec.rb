require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    let(:department) { create(:department) }
    let(:user) { create(:user, department: department) }
    it { should belong_to(:department).optional }
    it { should have_many(:tickets).class_name('Ticket').with_foreign_key('creator_id') }
    it { should have_many(:assigned_tickets).class_name('Ticket').with_foreign_key('assigned_to_id') }
    it { should have_many(:messages) }
    it { should have_one_attached(:profile_pic) }
    it "upon deleting user decrease department's user count by -1" do
      expect{ user.destroy }.to change { department.users.count }.by(-1)
    end
  end

  describe 'validations' do
    let(:user) { create(:user) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :contact }
    it { should validate_presence_of :department_id }
    it { should validate_presence_of :dob }
    it 'validates that age is above given age limit' do
      user.dob = '2007-04-01'
      user.validate
      expect(user.errors[:dob]).to include('must be greater than 18.') 
    end
  end

  describe 'scopes' do
    let(:department) { create(:department) }
    let(:user) { create(:user, department: department) }
    it 'return user of given department' do
      expect(User.department_users(department)).to include(user)
    end
  end

  describe 'after_create' do 
    let(:user) { create(:user, role: 'admin') }
    it 'add specified role' do
      expect(user.has_role?(:admin)).to be(true)
    end
  end
end
