class YandexService
  ARRAY_PATTERN = /\[.*\]/
  URI_HOST = 'news.yandex.ru'.freeze
  URI_PATH = '/ru/index5.utf8.js'.freeze

  def initialize
    @post = Post.yandex
  end

  def update_news
    # return if forced is relevant
    news = request_news
    return unless news
    @recent_post = news.max_by { |post| post['ts'] }
    @recent_time = Time.at(@recent_post['ts'].to_i)
    return Post.create! post_params unless @post
    @post.update post_params if @recent_time > @post.posted_at
  end

  private

  def post_params
    {
      title: @recent_post['title'],
      description: @recent_post['descr'],
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
