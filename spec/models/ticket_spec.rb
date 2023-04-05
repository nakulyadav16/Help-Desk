require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) { build :ticket }
  let(:ticket2) { build :ticket, assigned_to_id: 1, creator_id: 1 }
  context 'Ticket' do
    it 'is valid' do
      expect(ticket[:assigned_to_id]).not_to eq(ticket[:creator_id])
      expect(ticket[:department_id]).not_to be_nil
      expect(ticket[:status]).to eq('open')
    end

    it 'is invalid' do
      expect(Ticket.create[:id]).to be nil
      expect(ticket2[:assigned_to_id]).to eq(ticket2[:creator_id])
      expect(Ticket.create[:subject]).to be nil
    end

    it 'is created succesfully' do
      ticket.save
      expect(ticket.messages.count).to be 0
      expect(ticket.ticket_histories.count).to be 0
    end
  end

  context 'when ticket is not created' do
    it 'message can not be created' do
      expect { Ticket.create.messages.create! }.to raise_error(ActiveRecord::RecordNotSaved)
    end

    it 'histroy can not be created' do
      expect { Ticket.create.ticket_histories.create! }.to raise_error(ActiveRecord::RecordNotSaved)
    end
  end
end
