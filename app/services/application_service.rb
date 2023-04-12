class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  def change_order(tickets)
    Ticket.order_by_due_date_and_priority(tickets)
  end
end