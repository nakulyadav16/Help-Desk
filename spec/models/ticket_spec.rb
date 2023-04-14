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
    let(:user) { create(:user) }
    let(:ticket1) { create(:ticket, assigned_to: user, status: 'in_progress') }
    let(:ticket2) { create(:ticket, assigned_to: user, status: 'closed') }
    let(:ticket3) { create(:ticket, assigned_to: user, status: 'open') }
    it 'return assigned ticket which have status either in_progress or closed' do
      expect(Ticket.user_assigned_tickets(user)).to include(ticket1, ticket2)
    end

    it 'return newly raised ticket' do
      expect(Ticket.new_request_tickets(user)).to include(ticket3)
    end
  end

  describe 'aasm' do
    let(:ticket) { create(:ticket) }
    it 'initaily ticket should have open status' do
      expect(ticket[:status]).to eq('open') 
    end

    it 'after accept event transit status form open or reopen to in_progress' do
      ticket.accept!
      expect(ticket[:status]).to eq("in_progress")
    end

    it 'after reject event transit status form open or reopen to rejected' do
      ticket[:status] = 're_open'
      ticket.reject!
      expect(ticket[:status]).to eq("rejected")
    end

    it 'after satisfy event transit status form in_progress to closed' do
      ticket[:status] = 'in_progress'
      ticket.satisfy!
      expect(ticket[:status]).to eq("closed")
    end

    it 'after upgrade event transit status form closed to re_open' do
      ticket[:status] = 'closed'
      ticket.upgrade!
      expect(ticket[:status]).to eq("re_open")
    end

    it 'after close event transit status form open , re_open or rejected to closed' do
      ticket[:status] = 'rejected'
      ticket.close!
      expect(ticket[:status]).to eq("closed")
    end

  end
end
