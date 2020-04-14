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

  describe 'valid?' do
    let(:card) { Trello::Card.new('name' => name, 'idList' => list_id) }

    context 'when name is nil' do
      let(:name) { nil }
      let(:list_id) { 1 }

      specify { expect(card.valid?).to eq(false) }
    end

    context 'when list_id is nil' do
      let(:name) { 'Card Name' }
      let(:list_id) { nil }

      specify { expect(card.valid?).to eq(false) }
    end

    context "when name and list_id both aren't nil" do
      let(:name) { 'Card' }
      let(:list_id) { 1 }

      specify { expect(card.valid?).to eq(true) }
    end
  end

end
