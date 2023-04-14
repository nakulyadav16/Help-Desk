import consumer from "./consumer"

$(document).on('turbolinks:load', () => { 
  let url = window.location.href
  console.log(url)

  if (url.indexOf("tickets/") != -1 )
  {
    const ticket_element = document.getElementById('ticket-id')
    const ticket_id = Number(ticket_element.getAttribute('data-ticket-id'))

    // console.log(consumer.subscriptions)
    consumer.subscriptions.subscriptions.forEach( (subscription) => {
      consumer.subscriptions.remove(subscription)
    })
    consumer.subscriptions.create( { channel: "TicketChannel", ticket_id: ticket_id}, {
      connected() {
        console.log("connected to " + ticket_id)
      },
      disconnected() {
        console.log("disconnected from " + ticket_id)
      },
      received(data) {
        console.log(data)
        const user_element = document.getElementById('user-id')
        const user_id = Number(user_element.getAttribute('data-user-id'))
        let new_message;
        
        new_message = `<div class="message  ${ (user_id === data.message.user_id)? "me":"" }" ><div class="content-box"><div class="content"> ${ data.message.content} </div> <div class="author"> ${data.user_name} </div> <br> </div> </div>` ;
        
        if (data.documents != null)
        {
          data.documents.forEach(function(element, index){
              console.log(`<a href="${element[0]}">${element[1]}</a>`);
          });
        }

        const message_container = document.getElementById('messages')
        message_container.innerHTML = message_container.innerHTML + new_message
        $('#message_content').val('')
      }
    });
  }
})
