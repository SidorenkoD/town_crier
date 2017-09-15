FactoryGirl.define do
  factory :yandex_post, class: Post do
    title 'Yandex News'
    description 'Yandex description'
    posted_at Time.now
  end

  factory :yandex_news, class: Hash do
    moment = Time.now
    time moment.strftime('%H:%M')
    date Date.today
    ts moment.to_i.to_s
    url 'http://news.yandex.ru/yandsearch?cl4url=russian.rt.com%2Fworld%2Ffoto%2F123456-random-news&from=js'
    title 'Random title'
    descr 'Random description'
    fake_time moment.change(usec: 0)

    initialize_with { attributes.stringify_keys }
  end
end
