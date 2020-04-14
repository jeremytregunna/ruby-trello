require 'spec_helper'

RSpec.describe Trello::Card do

  describe '.path_name' do
    specify { expect(Trello::Card.path_name).to eq('card') }
  end

  describe '.closed?' do
    specify { expect(Trello::Card.new('closed' => true).closed?).to eq(true) }
    specify { expect(Trello::Card.new('closed' => false).closed?).to eq(false) }
  end

end
