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
      before do
        allow(item)
          .to receive(:state)
          .and_return state
      end

      context 'when complete' do
        let(:state) { 'complete' }
        it { expect(item).to be_complete }
      end

      context 'when complete' do
        let(:state) { 'incomplete' }
        it { expect(item).not_to be_complete }
      end
    end

    describe "#update_fields" do
      it "does not set any fields when the fields argument is empty" do
        expected = {
          'id' => 'id',
          'name' => 'name',
          'type' => 'type',
          'state' => 'state',
          'pos' => 'pos'
        }

        item = Item.new(expected)

        item.update_fields({})

        expected.each do |key, value|
          expect(item.send(value)).to eq expected[key]
        end
      end
    end
  end
end
