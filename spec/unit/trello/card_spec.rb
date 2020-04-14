require 'spec_helper'

RSpec.describe Trello::Card do

  describe '.path_name' do
    specify { expect(Trello::Card.path_name).to eq('card') }
  end

  describe '#closed?' do
    specify { expect(Trello::Card.new('closed' => true).closed?).to eq(true) }
    specify { expect(Trello::Card.new('closed' => false).closed?).to eq(false) }
  end

  describe '#close' do
    let(:card) { Trello::Card.new('closed' => false) }

    it 'can mark card as closed' do
      card.close
      expect(card.closed).to eq(true)
    end
  end

  describe 'close!' do
    let(:card) { Trello::Card.new('closed' => false) }

    it 'will call save' do
      expect(card).to receive(:save)
      card.close!
    end
  end

end
