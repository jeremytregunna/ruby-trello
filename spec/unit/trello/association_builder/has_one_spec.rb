require 'spec_helper'

RSpec.describe Trello::AssociationBuilder::HasOne do

  describe '.build' do
    around do |example|
      class FakeBoard; end

      example.run

      Object.send(:remove_const, 'FakeBoard')
    end

    it 'build has one finder method' do
      Trello::AssociationBuilder::HasOne.build(FakeBoard, 'organization', {})

      expect(FakeBoard.new.respond_to?(:organization)).to eq(true)
    end

    it 'the finder method return result from Trello::AssociationFetcher' do
      fake_board = FakeBoard.new
      has_one_fetcher = instance_double(Trello::AssociationFetcher::HasOne)
      allow(Trello::AssociationFetcher::HasOne)
        .to receive(:new)
        .with(fake_board, 'organization', {})
        .and_return(has_one_fetcher)

      result = double('result')
      allow(has_one_fetcher).to receive(:fetch).and_return(result)

      Trello::AssociationBuilder::HasOne.build(FakeBoard, 'organization', {})
      expect(fake_board.organization).to eq(result)
    end
  end

end
