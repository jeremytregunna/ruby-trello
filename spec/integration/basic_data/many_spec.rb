require 'spec_helper'

module Trello
  describe BasicData do
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
end
