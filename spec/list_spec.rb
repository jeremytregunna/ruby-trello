require 'spec_helper'

module Trello
  describe List do
    include Helpers

    let(:list) { client.find(:list, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before(:each) do
      client.stub(:get).with('/lists/abcdef123456789123456789', {}).and_return JSON.generate(lists_details.first)
      client.stub(:get).with('/boards/abcdef123456789123456789', {}).and_return JSON.generate(boards_details.first)
    end

    context 'finding' do
      let(:client) { Trello.client }

      it 'delegates to client#find' do
        client.should_receive(:find).with(:list, 'abcdef123456789123456789', {})
        List.find('abcdef123456789123456789')
      end

      it 'is equivalent to client#find' do
        List.find('abcdef123456789123456789').should eq(list)
      end
    end

    context 'creating' do
      let(:client) { Trello.client }

      it 'creates a new record' do
        list = List.new(lists_details.first)
        list.should be_valid
      end

      it 'must not be valid if not given a name' do
        list = List.new(lists_details.first.except('name'))
        list.should_not be_valid
      end

      it 'must not be valid if not given a list id' do
        list = List.new(lists_details.first.except('id'))
        list.should_not be_valid
      end

      it 'creates a new record and saves it on Trello', refactor: true do
        payload = {
          name: 'Test List',
          board_id: 'abcdef123456789123456789',
          pos: 42
        }

        result = JSON.generate(payload)

        expected_payload = {name: 'Test List', closed: false, idBoard: 'abcdef123456789123456789', pos: 42}

        client.should_receive(:post).with('/lists', expected_payload).and_return result

        list = List.create(payload)

        list.class.should be List
      end
    end

    context 'updating' do
      it 'updating name does a put on the correct resource with the correct value' do
        expected_new_name = 'xxx'

        payload = {
          name: expected_new_name,
          closed: false,
          pos: list.pos
        }

        client.should_receive(:put).once.with('/lists/abcdef123456789123456789', payload)
        list.name = expected_new_name
        list.save
      end

      it 'updates position' do
        new_position = 42
        payload = {
          name: list.name,
          closed: list.closed,
          pos: new_position
        }

        client.should_receive(:put).once.with('/lists/abcdef123456789123456789', payload)
        list.pos = new_position
        list.save
      end
    end

    context 'fields' do
      it 'gets its id' do
        list.id.should == lists_details.first['id']
      end

      it 'gets its name' do
        list.name.should == lists_details.first['name']
      end

      it 'knows if it is open or closed' do
        list.closed.should == lists_details.first['closed']
      end

      it 'has a board' do
        list.board.should == Board.new(boards_details.first)
      end

      it 'gets its position' do
        list.pos.should == lists_details.first['pos']
      end
    end

    context 'actions' do
      it 'has a list of actions' do
        client.stub(:get).with('/lists/abcdef123456789123456789/actions', { filter: :all }).and_return actions_payload
        list.actions.count.should be > 0
      end
    end

    context 'cards' do
      it 'has a list of cards' do
        client.stub(:get).with('/lists/abcdef123456789123456789/cards', { filter: :open }).and_return cards_payload
        list.cards.count.should be > 0
      end

      it 'moves cards to another list' do
        other_list = List.new(lists_details.first.merge(id: 'otherListID', cards: []))

        client.stub(:post).with('/lists/abcdef123456789123456789/moveAllCards', { idBoard: other_list.board_id, idList: other_list.id }).and_return cards_payload
        list.move_all_cards(other_list).should eq cards_payload
      end
    end

    describe '#closed?' do
      it 'returns the closed attribute' do
        expect(list.closed?).not_to be(true)
      end
    end

    describe '#close' do
      it 'updates the close attribute to true' do
        list.close
        expect(list.closed).to be(true)
      end
    end

    describe '#close!' do
      it 'updates the close attribute to true and saves the list' do
        client.should_receive(:put).once.with('/lists/abcdef123456789123456789', {
          name: list.name,
          closed: true,
          pos: list.pos
        })

        list.close!
      end
    end
  end
end
