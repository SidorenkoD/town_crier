class NewsletterChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'newsletter_channel'
  end
end
