require 'spec_helper'

RSpec.describe 'Trello::Label#delete' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id' do
    VCR.use_cassette('label_delete') do
      label = Trello::Label.find('5fa7f18181d21312d8c729ae')
      expect(label).to be_a(Trello::Label)

      label.delete

      expect {
        Trello::Label.find('5fa7f18181d21312d8c729ae')
      }.to raise_error Trello::Error, 'The requested resource was not found.'
    end
  end

end
