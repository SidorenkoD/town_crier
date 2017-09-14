class YandexService
  ARRAY_PATTERN = /\[.*\]/
  URI_HOST = 'news.yandex.ru'.freeze
  URI_PATH = '/ru/index5.utf8.js'.freeze

  def initialize
    @yandex_post = Post.yandex
  end

  def update_news
    news = request_news
    return unless news
    recent_post = news.max_by { |post| post['ts'] }
    @recent_time = get_post_timestamp recent_post
    return Post.create post_params(recent_post) unless @yandex_post
    @yandex_post.update post_params(recent_post) if @recent_time > @yandex_post.posted_at
  end

  private

  def get_post_timestamp(post)
    timestamp = post['ts'].to_i
    Time.at timestamp
  end

  def post_params(post)
    {
      title: post['title'],
      description: post['descr'],
      posted_at: @recent_time
    }
  end

  def request_news
    raw_result = Net::HTTP.get URI_HOST, URI_PATH
    encoded_result = raw_result.force_encoding 'UTF-8'
    result = encoded_result[ARRAY_PATTERN]
    result ? JSON.parse(result) : nil
  end
end
