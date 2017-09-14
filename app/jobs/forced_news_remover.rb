class ForcedNewsRemover < Que::Job
  def run
    YandexService.new.update_news
    post = Post.yandex
    NewsletterChannel.broadcast_post post if post
  end

  def self.update_remover(run_at)
    Que.execute "DELETE FROM que_jobs WHERE job_class = '#{name}'"
    enqueue run_at: run_at
  end
end
