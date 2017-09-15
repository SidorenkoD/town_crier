RSpec.configure do |config|
  config.before(:suite) do
    RedisTest.start
    RedisTest.configure(:default)
  end

  config.after(:each) do
    RedisTest.clear
  end

  config.after(:suite) do
    RedisTest.stop
  end
end
