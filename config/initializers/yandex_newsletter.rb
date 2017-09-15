if !Rails.env.test? && Que.execute("SELECT * FROM information_schema.tables WHERE table_name = 'que_jobs'")
  Que.execute 'DELETE FROM que_jobs'
  YandexNewsPuller.enqueue
end
