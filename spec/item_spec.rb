require 'spec_helper'

module Trello
  describe Item do
    let(:details) {
      {
        'id'   => 'abcdef123456789123456789',
        'name' => 'test item',
        'type' => 'check',
        'state' => 'complete',
        'pos' => 0
      }
    }

    let(:item) { Item.new(details) }

    it 'gets its id' do
      expect(item.id).to eq details['id']
    end

    it 'gets its name' do
      expect(item.name).to eq details['name']
    end

    it 'knows its type' do
      expect(item.type).to eq details['type']
    end

    it 'knows its state' do
      expect(item.state).to eq details['state']
    end

    it 'knows its pos' do
      expect(item.pos).to eq details['pos']
    end

    describe '#complete?' do
      it "knows when it is complete" do
        allow(@item).to receive(:state).and_return "complete"
        expect(@item).to be_complete
      end

      it "knowns when it is not complete" do
        allow(@item).to receive(:state).and_return "incomplete"
        expect(@item).to_not be_complete
      end
    end
  end
end
