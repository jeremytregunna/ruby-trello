require 'spec_helper'
require 'trello/hash'

describe Hash, '#jsoned_into' do
  include Helpers

  it "should convert a single parsed json into card" do
    Trello::Card.should_receive(:new).once.with(cards_details.first)
    cards_details.first.jsoned_into(Trello::Card)
  end
end
