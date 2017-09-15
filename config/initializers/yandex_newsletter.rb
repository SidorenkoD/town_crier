unless Rails.env.test?
  Que.execute 'DELETE FROM que_jobs'
  YandexNewsPuller.enqueue
end
