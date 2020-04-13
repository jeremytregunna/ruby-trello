require 'spec_helper'

RSpec.describe 'Trello::Card#cover_image' do
  include IntegrationHelpers

  before { setup_trello }

  it 'can get cover_image' do
    VCR.use_cassette('get_cover_image_of_card') do
      card = Trello::Card.find('5e946acb3cc40322434c214e')
      cover_image = card.cover_image
      expect(cover_image).to be_a(Trello::CoverImage)
      expect(cover_image.id).not_to be_nil
      expect(cover_image.name).not_to be_nil
    end
  end

end
