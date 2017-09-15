require 'rails_helper'

VCR_PATH = File.join Rails.root, 'spec', 'fixtures'
INVALID_VCR_PATH = File.join VCR_PATH, 'invalid_yandex_vcr.txt'
VALID_VCR_PATH = File.join VCR_PATH, 'valid_yandex_vcr.txt'

RSpec.describe YandexService, type: :yandex do
  it 'creates a post' do
    stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: File.read(VALID_VCR_PATH), headers: {})
    service = YandexService.new
    expect(service.update_news).to be_instance_of(Post)
  end

  it 'stops' do
    stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: File.read(INVALID_VCR_PATH), headers: {})
    service = YandexService.new
    expect(service.update_news).to be(nil)
  end
end
