require 'rails_helper'

RSpec.describe Department, type: :model do

  describe 'associations' do
    let(:department) { create(:department) }
    let(:user) { create(:user, department: department) }
    it { should have_many(:users).dependent(:destroy) }
    it 'upon destroying department its associated user should be destroy' do 
      expect{ department.destroy }.to change { User.count }.by(-1)
    end
  end

  describe 'validations' do 
    it { should validate_presence_of :department_name }
  end

  describe 'before_save' do 
    let(:department) { create(:department, department_name: 'finance') }
    it 'create department and capitalize name' do
      expect(department.department_name).to eq('Finance')
    end
  end
end
