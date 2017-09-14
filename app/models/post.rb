class Post < ApplicationRecord
  validates :title, :description, :posted_at, presence: true
  validates :relevant_until, presence: true, if: proc { |post| post.forced }

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
end
