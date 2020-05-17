require 'spec_helper'

RSpec.describe 'Trello::Board#organization' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get organization' do
    VCR.use_cassette('can_get_organization_of_board') do
      board = Trello::Board.find('5e93ba98614ac22d22f085c4')
      organization = board.organization

      expect(organization).to be_a(Trello::Organization)
      expect(organization.id).not_to be_nil
      expect(organization.display_name).to eq('Integration Test 1')
    end
  end

end
