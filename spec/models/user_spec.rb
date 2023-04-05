require 'rails_helper'

RSpec.describe User, type: :model do
  context 'creating new user' do
    let(:user) { build :user }
    let(:user2) { build :user, email: user.email, contact: user.contact }

    it 'is valid' do
      expect(user).to be_valid
    end

    it 'is partially completed registration' do
      expect(User.create[:id]).to be nil
      expect { User.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should raise error when duplicate contact is entered' do
      user.save
      expect(user2.save).to be(false)
    end
  end

  context 'before user registration' do
    it 'user can not have tickets' do
      expect { User.create.tickets.create! }.to raise_error(ActiveRecord::RecordNotSaved)
      expect(User.create.tickets.count).to be 0
    end

    it 'user can not have messages' do
      expect { User.create.messages.create! }.to raise_error(ActiveRecord::RecordNotSaved)
      expect(User.create.messages.count).to be 0
    end
  end
end
