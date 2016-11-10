require 'spec_helper'
require 'trello/core_ext/array'

describe Array, '#jsoned_into' do
  include Helpers

  it "should convert an array of parsed json into cards" do
    expected = cards_details.map do |card_details|
      card_details.jsoned_into(Trello::Card)
    end
    expect(cards_details.jsoned_into(Trello::Card)).to eq(expected)
  end
end
