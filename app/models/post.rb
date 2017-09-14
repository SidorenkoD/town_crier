class Post < ApplicationRecord
  validates :title, :description, :posted_at, presence: true
  validates :relevant_until, presence: true, if: proc { |post| post.forced }

  after_save :broadcast_post
  after_save :update_remover, if: proc { |post| post.forced }

  class << self
    def forced; find_by(forced: true); end

    def relevant
      relevant_post = forced
      yandex_post = yandex
      return yandex_post unless relevant_post
      Time.now > relevant_post.relevant_until ? yandex_post : relevant_post
    end

    def yandex; find_by(forced: false); end
  end

  private

  def broadcast_post
    NewsletterChannel.broadcast_post self
  end

  def update_remover
    ForcedNewsRemover.update_remover relevant_until
  end
end
