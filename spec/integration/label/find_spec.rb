require 'spec_helper'

RSpec.describe 'Trello::Label#find' do
  include IntegrationHelpers

  before { setup_trello }

  it 'find with id' do
    VCR.use_cassette('label_find_with_id') do
      label = Trello::Label.find('5e70f5be7669b225494e4ff8')
      expect(label).to be_a(Trello::Label)

      expect(label.id).not_to be_nil
      expect(label.board_id).not_to be_nil
      expect(label.name).not_to be_nil
      expect(label.color).not_to be_nil
    end
  end

end
