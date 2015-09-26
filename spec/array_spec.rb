require 'spec_helper'
require 'trello/core_ext/array'

describe Array, '#jsoned_into' do
  include Helpers

  it "should convert an array of parsed json into cards" do
    expect(cards_details.jsoned_into(Trello::Card)).to eq([cards_details.first.jsoned_into(Trello::Card)])
  end
end
