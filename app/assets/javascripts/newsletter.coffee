App.room = App.cable.subscriptions.create "NewsletterChannel",
  received: (data) ->
    $('#title').html data['title']
    $('#description').html data['description']
    $('#date').html data['date']
