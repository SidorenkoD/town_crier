require 'rails_helper'

RSpec.describe YandexService do
  let(:yandex_post) { create :yandex_post }
  let(:irrelevant_yandex_post) { create :yandex_post, posted_at: 1.minutes.before(Time.now) }
  let(:yandex_news) { build :yandex_news }
  let(:service) { YandexService.new }

  describe '#initialize' do
    context 'yandex post persists' do
      it 'contains yandex post as an attribute' do
        yandex_post
        service_post = service.instance_variable_get :@yandex_post
        expect(service_post).to eq(yandex_post)
      end
    end

    context 'yandex post is abscent' do
      it 'contains nil as an attribute' do
        service_post = service.instance_variable_get :@yandex_post
        expect(service_post).to eq(nil)
      end
    end
  end

  describe '#request_news' do
    subject { service.send :request_news }

    context 'Yandex response is valid' do
      before { stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: file_fixture(VALID_VCR).read, headers: {}) }

      it 'returns array of 5 latest news' do
        expect(subject).to be_kind_of(Array)
        expect(subject.count).to eq(5)
      end

      it 'returns array of hashes with required keys' do
        subject.each do |news|
          expect(news).to be_kind_of(Hash)
          REQUIRED_KEYS.each { |key| expect(news).to have_key(key) }
        end
      end
    end

    context 'Yandex response is invalid' do
      before { stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: file_fixture(INVALID_VCR).read, headers: {}) }

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end
  end

  describe '#get_post_timestamp' do
    subject { service.send :get_post_timestamp, yandex_news }

    it 'extracts timestamp from post' do
      expect(subject).to be_kind_of(Time)
      expect(subject).to eq(yandex_news['fake_time'])
    end
  end


  describe '#update_news' do
    subject { service.update_news }

    context 'Yandex response is valid' do
      context 'yandex post persists' do
        context 'requested yandex post is newer than persisted' do
          before do
            response_body = file_fixture(VALID_VCR).read
            @posted_at = 1.minute.from_now.change(usec: 0)
            response_body.sub!(/1505432811/, @posted_at.to_i.to_s)
            stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: response_body, headers: {})
            irrelevant_yandex_post
          end

          it 'updates persisted post' do
            expect(subject).to eq(true)
            post = Post.last
            expect(post.title).to eq(RELEVANT_TITLE)
            expect(post.description).to eq(RELEVANT_DESCRIPTION)
            expect(post.posted_at).to eq(@posted_at)
          end
        end

        context 'requested yandex post is older than persisted' do
          before do
            stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: file_fixture(VALID_VCR).read, headers: {})
            yandex_post
          end

          it 'does nothing' do
            expect(subject).to eq(nil)
          end
        end
      end

      context 'yandex post is abscent' do
        before { stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: file_fixture(VALID_VCR).read, headers: {}) }

        it 'creates new post' do
          expect(subject).to be_kind_of(Post)
          expect(subject.title).to eq(RELEVANT_TITLE)
          expect(subject.description).to eq(RELEVANT_DESCRIPTION)
          posted_at = Time.at RELEVANT_TIMESTAMP
          expect(subject.posted_at).to eq(posted_at)
        end
      end
    end

    context 'Yandex response is invalid' do
      before { stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: file_fixture(INVALID_VCR).read, headers: {}) }

      it 'does nothing' do
        expect(subject).to eq(nil)
      end
    end
  end
end
