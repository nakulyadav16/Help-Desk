require 'rails_helper'

RSpec.describe Department, type: :model do
  context 'creating department' do
    let(:department) { build :department }
    let(:department2) { build :department, department_name: department.department_name }

    it 'is valid' do
      expect(department).to be_valid
    end

    it 'is invalid' do
      expect(department2[:department_name]).to eq(department[:department_name])
    end

    it 'is successfully done' do
      department.save
      expect(department[:id]).not_to be nil
      expect(department[:department_name]).to be_present
    end
  end
end
