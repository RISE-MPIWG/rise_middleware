App.user_info = App.cable.subscriptions.create "UserInfoChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    switch(data['type'])
      when 'notice'
        toastr.info(data['message'])
      when 'error'
      	toastr.error(data['message'])
