class NewsletterChannel < ApplicationCable::Channel
  class << self
    def broadcast_post(post)
      ActionCable.server.broadcast to_s,
                                   title: post.title,
                                   description: post.description,
                                   date: post.posted_at.to_s
    end

    def to_s
      name.underscore
    end
  end

  def subscribed
    stream_from self.class.to_s
  end
end
