class YandexNewsPuller < Que::Job
  @run_at = proc { 1.minute.from_now }

  def run
    YandexService.new.update_news unless Post.relevant&.forced
    YandexNewsPuller.enqueue
  end
end
