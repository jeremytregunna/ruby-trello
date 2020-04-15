require 'spec_helper'

RSpec.describe 'Trell::Card add and remove attachment' do
  include IntegrationHelpers

  before { setup_trello }

  describe '#add_attachment' do
    it 'can success add an attachment(file) on a card' do
      VCR.use_cassette('can_add_a_file_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
        file = File.new('spec/integration/card/add_and_remove_attachment_spec.rb', 'r')

        response = card.add_attachment(file)
        expect(response.code).to eq(200)
        body = JSON.parse(response.body)
        expect(body['name']).to eq('add_and_remove_attachment_spec.rb')
      end
    end

    it 'can success add and attachment(url) on a card' do
      VCR.use_cassette('can_add_a_file_from_url_on_a_card') do
        card = Trello::Card.find('5e95d1b4f43f9a06497f17f7')
        file_url = 'https://upload.wikimedia.org/wikipedia/en/6/6b/Hello_Web_Series_%28Wordmark%29_Logo.png'

        response = card.add_attachment(file_url, 'hello.png')
        expect(response.code).to eq(200)
        body = JSON.parse(response.body)
        expect(body['name']).to eq('hello.png')
      end
    end
  end
end
