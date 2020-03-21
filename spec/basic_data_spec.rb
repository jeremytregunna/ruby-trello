require 'spec_helper'

module Trello
  describe BasicData do
    describe "equality" do
      specify "two objects of the same type are equal if their id values are equal" do
        data_object = Card.new('id' => 'abc123')
        other_data_object = Card.new('id' => 'abc123')

        expect(data_object).to eq(other_data_object)
      end

      specify "two object of the samy type are not equal if their id values are different" do
        data_object = Card.new('id' => 'abc123')
        other_data_object = Card.new('id' => 'def456')

        expect(data_object).not_to eq(other_data_object)
      end

      specify "two object of different types are not equal even if their id values are equal" do
        card = Card.new('id' => 'abc123')
        list = List.new('id' => 'abc123')

        expect(card.id).to eq(list.id)
        expect(card).to_not eq(list)
      end
    end

    describe "hash equality" do
      specify "two objects of the same type point to the same hash key" do
        data_object = Card.new('id' => 'abc123')
        other_data_object = Card.new('id' => 'abc123')

        hash = {data_object => 'one'}

        expect(hash[other_data_object]).to eq('one')
      end

      specify "two object of the same type with different ids do not point to the same hash key" do
        data_object = Card.new('id' => 'abc123')
        other_data_object = Card.new('id' => 'def456')

        hash = {data_object => 'one'}

        expect(hash[other_data_object]).to be_nil
      end

      specify "two object of different types with same ids do not point to the same hash key" do
        card = Card.new('id' => 'abc123')
        list = List.new('id' => 'abc123')

        hash = {card => 'one'}

        expect(hash[list]).to be_nil
      end
    end
  end

  describe '.many' do
    let(:client_double) { double('client') }
    let(:cards) { double('cards') }

    around do |example|
      class FakeCard < BasicData
      end
      class FakeBoard < BasicData
        def update_fields(fields)
          attributes[:id] = fields[:id]
        end
      end

      example.run

      Trello.send(:remove_const, 'FakeBoard')
      Trello.send(:remove_const, 'FakeCard')
    end

    def mock_client_and_association(klass:, resource:, id:, path:, params:)
      resources = double('resources')
      allow(FakeBoard).to receive(:client).and_return(client_double)
      allow_any_instance_of(FakeBoard).to receive(:client).and_return(client_double)
      allow(client_double).to receive(:find_many).with(klass, "/#{resource}/#{id}/#{path}", params).and_return(resources)
      allow(MultiAssociation).to receive(:new).with(FakeBoard, resources).and_return(double('association', proxy: cards))
    end

    context 'when only pass in the name' do
      before do
        FakeBoard.class_eval { many :fake_cards }

        mock_client_and_association(
          klass: Trello::FakeCard,
          resource: 'fakeboards',
          id: 1,
          path: 'fake_cards',
          params: {}
        )
      end

      it 'can get cards from client' do
        expect(FakeBoard.new(id: 1).fake_cards).to eq(cards)
      end
    end

    context 'when pass in name with in:' do
      before do
        FakeBoard.class_eval { many :fake_cards, in: 'boards' }

        mock_client_and_association(
          klass: Trello::FakeCard,
          resource: 'boards',
          id: 1,
          path: 'fake_cards',
          params: {}
        )
      end

      it 'can get cards from client' do
        expect(FakeBoard.new(id: 1).fake_cards).to eq(cards)
      end
    end

    context 'when pass in name with via:' do
      before do
        FakeBoard.class_eval { many :fake_cards, via: Card }

        mock_client_and_association(
          klass: Trello::Card,
          resource: 'fakeboards',
          id: 1,
          path: 'fake_cards',
          params: {}
        )
      end

      it 'can get cards from client' do
        expect(FakeBoard.new(id: 1).fake_cards).to eq(cards)
      end
    end

    context 'when pass in name with path:' do
      before do
        FakeBoard.class_eval { many :fake_cards, path: 'test' }

        mock_client_and_association(
          klass: Trello::FakeCard,
          resource: 'fakeboards',
          id: 1,
          path: 'test',
          params: {}
        )
      end

      it 'can get cards from client' do
        expect(FakeBoard.new(id: 1).fake_cards).to eq(cards)
      end
    end

    context 'when pass in name with other params' do
      before do
        FakeBoard.class_eval { many :fake_cards, test: 'test' }

        mock_client_and_association(
          klass: Trello::FakeCard,
          resource: 'fakeboards',
          id: 1,
          path: 'fake_cards',
          params: {test: 'test'}
        )
      end

      it 'can get cards from client' do
        expect(FakeBoard.new(id: 1).fake_cards).to eq(cards)
      end
    end
  end

end
