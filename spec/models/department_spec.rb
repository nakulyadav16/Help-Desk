require 'rails_helper'

RSpec.describe Department, type: :model do

  describe 'associations' do
    it { should have_many(:users) }
    it 'upon destroying department its associated user should be destroy' do 
      department = create(:department)
      user = create(:user, department: department)
      expect{ department.destroy }.to change { User.count }.by(-1)
    end
  end

  describe 'validations' do 
    it { should validate_presence_of :department_name }
  end

  describe 'before_save' do 
    it 'create department and capitalize name' do
      department = create(:department, department_name: 'finance')
      expect(department.department_name).to eq('Finance')
    end
  end
end
