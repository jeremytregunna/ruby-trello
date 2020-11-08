require 'spec_helper'

RSpec.describe 'Trell::Label.update!' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can update! a label' do
    VCR.use_cassette('can_success_update_bong_a_label') do
      label = Trello::Label.find('5fa7f18181d21312d8c729ae')

      expect(label.name).to eq('Test')
      expect(label.color).to eq('green')

      label.name = 'Test - Changed'
      label.color = 'red'

      label.update!

      expect(label.name).to eq('Test - Changed')
      expect(label.color).to eq('red')
    end
  end

end
