require 'spec_helper'

module Trello
  describe List do
    include Helpers

    let(:list) { client.find(:list, 'abcdef123456789123456789') }
    let(:client) { Client.new }

    before(:each) do
      allow(client)
        .to receive(:get)
        .with('/lists/abcdef123456789123456789', {})
        .and_return JSON.generate(lists_details.first)

      allow(client)
        .to receive(:get)
        .with('/boards/abcdef123456789123456789', {})
        .and_return JSON.generate(boards_details.first)
    end

    context 'finding' do
      let(:client) { Trello.client }

      it 'delegates to client#find' do
        expect(client)
          .to receive(:find)
          .with(:list, 'abcdef123456789123456789', {})

        List.find('abcdef123456789123456789')
      end

      it 'is equivalent to client#find' do
        expect(List.find('abcdef123456789123456789')).to eq(list)
      end
    end

    context 'creating' do
      let(:client) { Trello.client }

      it 'creates a new record' do
        list = List.new(lists_details.first)
        expect(list).to be_valid
      end

      it 'must not be valid if not given a name' do
        list = List.new(lists_details.first.except('name'))
        expect(list).to_not be_valid
      end

      it 'must not be valid if not given a list id' do
        list = List.new(lists_details.first.except('id'))
        expect(list).to_not be_valid
      end

      it 'creates a new record and saves it on Trello', refactor: true do
        payload = {
          name: 'Test List',
          board_id: 'abcdef123456789123456789',
          pos: 42
        }

        result = JSON.generate(payload)

        expected_payload = {name: 'Test List', closed: false, idBoard: 'abcdef123456789123456789', pos: 42}

        expect(client)
          .to receive(:post)
          .with('/lists', expected_payload).and_return result

        list = List.create(payload)
        expect(list).to be_a List
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

        expect(client)
          .to receive(:put)
          .once
          .with('/lists/abcdef123456789123456789', payload)

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

        expect(client)
          .to receive(:put)
          .once
          .with('/lists/abcdef123456789123456789', payload)

        list.pos = new_position
        list.save
      end
    end

    context 'fields' do
      it 'gets its id' do
        expect(list.id).to eq lists_details.first['id']
      end

      it 'gets its name' do
        expect(list.name).to eq lists_details.first['name']
      end

      it 'knows if it is open or closed' do
        expect(list.closed).to eq lists_details.first['closed']
      end

      it 'has a board' do
        expect(list.board).to eq Board.new(boards_details.first)
      end

      it 'gets its position' do
        expect(list.pos).to eq lists_details.first['pos']
      end
    end

    context 'actions' do
      it 'has a list of actions' do
        allow(client)
          .to receive(:get)
          .with('/lists/abcdef123456789123456789/actions', { filter: :all })
          .and_return actions_payload

        expect(list.actions.count).to be > 0
      end
    end

    context 'cards' do
      it 'has a list of cards' do
        allow(client)
          .to receive(:get)
          .with('/lists/abcdef123456789123456789/cards', { filter: :open })
          .and_return cards_payload

        expect(list.cards.count).to be > 0
      end

      it 'moves cards to another list' do
        other_list = List.new(lists_details.first.merge(id: 'otherListID', cards: []))

        allow(client)
          .to receive(:post)
          .with('/lists/abcdef123456789123456789/moveAllCards', { idBoard: other_list.board_id, idList: other_list.id })
          .and_return cards_payload

        expect(list.move_all_cards(other_list)).to eq cards_payload
      end
    end

    describe '#closed?' do
      it 'returns the closed attribute' do
        expect(list).to_not be_closed
      end
    end

    describe '#close' do
      it 'updates the close attribute to true' do
        list.close
        expect(list).to be_closed
      end
    end

    describe '#close!' do
      it 'updates the close attribute to true and saves the list' do
        expect(client)
          .to receive(:put)
          .once
          .with('/lists/abcdef123456789123456789', {
            name: list.name,
            closed: true,
            pos: list.pos
          })

        list.close!
      end
    end
  end
end
