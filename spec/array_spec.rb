require 'spec_helper'
require 'core_ext/array'

describe Array, '#jsoned_into' do
  include Helpers

  it "should convert an array of parsed json into cards" do
    cards_details.jsoned_into(Trello::Card).should eq([cards_details.first.jsoned_into(Trello::Card)])
  end
end
