class TicketReminderWorker
	include Sidekiq::Worker

	def perform(*args)
		Ticket.where(status: "open").each do |ticket|
			TicketReminderJob.perform_later(ticket.id)
		end
	end
end