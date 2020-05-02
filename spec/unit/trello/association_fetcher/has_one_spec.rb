require 'spec_helper'

RSpec.describe Trello::AssociationFetcher::HasOne do

  describe '#new' do
    let(:board) { instance_double(Trello::Board) }
    let(:has_one) {
      Trello::AssociationFetcher::HasOne.new(board, 'organization', { using: :test_id })
    }

    it 'has model attribute' do
      expect(has_one.model).to eq(board)
    end

    it 'has name attribute' do
      expect(has_one.name).to eq('organization')
    end

    it 'has options attribute' do
      expect(has_one.options).to eq({ using: :test_id })
    end
  end

  describe '.fetch' do
    let(:board) { instance_double(Trello::Board) }
    let(:params) { instance_double(Trello::AssociationFetcher::HasOne::Params) }
    let(:fetch_result) { double('fetch result') }
    let(:has_one_fetcher) {
      Trello::AssociationFetcher::HasOne.new(board, 'organization', { using: :test_id })
    }

    it 'return result from HasOne::Fetch and HasOne::Params' do
      expect(Trello::AssociationFetcher::HasOne::Params)
        .to receive(:new)
        .with(
          association_owner: board,
          association_name: 'organization',
          association_options: { using: :test_id }
        ).and_return(params)
      expect(Trello::AssociationFetcher::HasOne::Fetch)
        .to receive(:execute)
        .with(params)
        .and_return(fetch_result)

      expect(has_one_fetcher.fetch).to eq(fetch_result)
    end
  end

end
