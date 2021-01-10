require 'spec_helper'

RSpec.describe 'Trello::Label.create' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can success create the custom_field' do
    VCR.use_cassette('can_success_create_a_label') do
      label = Trello::Label.create(
        name: 'Test',
        board_id: '5e70f5bed3f34a49e2f11409',
        color: 'green'
      )
      expect(label).to be_a(Trello::Label)

      expect(label.id).not_to be_nil
      expect(label.name).to eq('Test')
      expect(label.board_id).to eq('5e70f5bed3f34a49e2f11409')
      expect(label.color).to eq('green')
    end
  end
end
