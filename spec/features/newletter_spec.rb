require 'rails_helper'

feature 'Newsletter auto-refreshment', js: true do
  let(:yandex_post) { create :yandex_post }

  shared_examples 'monitoring home page news' do |persistance_flag|
    background do
      stub_request(:get, /#{YandexService::URI_HOST}/).to_return(status: 200, body: file_fixture(VALID_VCR).read, headers: {})
      @post = yandex_post if persistance_flag
    end

    scenario 'forced post submission refreshes home page news' do
      visit '/'
      expect(page).to have_content(@post&.title || RELEVANT_TITLE)
      page.switch_to_window page.open_new_window
      visit '/admin'
      fill_in 'post_title', with: 'Forced news'
      fill_in 'post_description', with: 'Forced description'
      find('.input-group-addon').click
      find('input[type=submit]').click
      page.switch_to_window page.windows.first
      expect(page).to have_content('Forced news')
      sleep 5
      visit page.current_url
      expect(page).to have_content(yandex_post.title)
    end
  end

  describe('with persisted yandex post') { it_should_behave_like 'monitoring home page news', true }
  describe('without persisted yandex post') { it_should_behave_like 'monitoring home page news' }
end
