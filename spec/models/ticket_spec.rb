require 'rails_helper'

RSpec.describe Ticket, type: :model do
  
  describe 'association' do
    it { should belong_to(:creator).class_name('User') }
    it { should belong_to(:assigned_to).class_name('User') }
    it { should belong_to(:department) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:ticket_histories).dependent(:destroy) }
    it { should have_many_attached(:documents) }
  end

  describe 'validations' do
    it { should validate_presence_of(:subject) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:department_id) }
    it { should validate_presence_of(:assigned_to) }
    it { should validate_presence_of(:priority) }
  end

  describe 'scopes' do
    it 'return assigned ticket which have status either in_progress or closed' do
      user = create(:user)
      ticket1 = create(:ticket, assigned_to: user, status: 'in_progress')
      ticket2 = create(:ticket, assigned_to: user, status: 'closed')
      expect(Ticket.user_assigned_tickets(user)).to include(ticket1, ticket2)
    end

    it 'return newly raised ticket' do
      user = create(:user)
      ticket = create(:ticket, assigned_to: user)
      expect(Ticket.new_request_tickets(user)).to include(ticket)
    end
  end
end
