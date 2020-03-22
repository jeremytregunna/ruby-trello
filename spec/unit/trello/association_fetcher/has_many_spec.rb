require 'spec_helper'

RSpec.describe Trello::AssociationFetcher::HasMany do

  describe '#new' do
    let(:board) { instance_double(Trello::Board) }
    let(:has_many) {
      Trello::AssociationFetcher::HasMany.new(board, 'cards', {filter: :all})
    }

    it 'has model_class attribute' do
      expect(has_many.model).to eq(board)
    end

    it 'has name attribute' do
      expect(has_many.name).to eq('cards')
    end

    it 'has options attribute' do
      expect(has_many.options).to eq({filter: :all})
    end
  end

  describe '.fetch' do
    let(:board) { instance_double(Trello::Board) }
    let(:params) { instance_double(Trello::AssociationFetcher::HasMany::Params) }
    let(:fetch_result) { double('fetch result') }
    let(:has_many_fetcher) {
      Trello::AssociationFetcher::HasMany.new(board, 'cards', {filter: :all})
    }

    it 'return the result from HasMany::Fetch and HasMany::Params' do
      expect(Trello::AssociationFetcher::HasMany::Params)
        .to receive(:new)
        .with(
          association_owner: board,
          association_name: 'cards',
          association_options: { filter: :all },
          filter: { a: 1 }
        ).and_return(params)
      expect(Trello::AssociationFetcher::HasMany::Fetch)
        .to receive(:execute)
        .with(params)
        .and_return(fetch_result)

      expect(has_many_fetcher.fetch(a: 1)).to eq(fetch_result)
    end
  end

end
