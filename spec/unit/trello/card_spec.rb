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

  describe '#move_to_list_on_any_board' do
    let(:card) { Trello::Card.new(board_id: 'board-aaa') }
    let(:move_to_list_on_any_board) { card.move_to_list_on_any_board('listid') }

    let(:board) { Trello::Board.new(id: 'board-aaa') }
    let(:target_list) { Trello::List.new(board_id: target_board_id) }

    before do
      allow(Trello::List).to receive(:find).with('listid').and_return(target_list)
      allow(card).to receive(:board).and_return(board)
    end

    context 'when target list is in the same board' do
      let(:target_board_id) { 'board-aaa' }

      it 'call #move_to_list on card' do
        expect(card).to receive(:move_to_list).with('listid')

        move_to_list_on_any_board
      end
    end

    context 'when target list is in a different board' do
      let(:target_board_id) { 'board-bbb' }
      let(:target_board) { Trello::Board.new(id: 'board-bbb') }

      before { allow(Trello::Board).to receive(:find).with('board-bbb').and_return(target_board) }

      it 'call #move_to_board on card' do
        expect(card).to receive(:move_to_board).with(target_board, target_list)

        move_to_list_on_any_board
      end
    end
  end

end
