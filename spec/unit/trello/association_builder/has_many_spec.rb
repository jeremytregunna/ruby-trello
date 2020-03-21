require 'spec_helper'

RSpec.describe Trello::AssociationBuilder::HasMany do

  describe '.build' do
    around do |example|
      class FakeBoard; end

      example.run

      Object.send(:remove_const, 'FakeBoard')
    end

    it 'build has many finder method' do
      Trello::AssociationBuilder::HasMany.build(FakeBoard, 'boards', {})

      expect(FakeBoard.new.respond_to?(:boards)).to eq(true)
    end

    it 'the finder method return result from Trello::AssociationFetcher' do
      fake_board = FakeBoard.new
      has_many_fetcher = instance_double(Trello::AssociationFetcher::HasMany)
      allow(Trello::AssociationFetcher::HasMany)
        .to receive(:new)
        .with(fake_board, 'boards', {})
        .and_return(has_many_fetcher)

      result = double('result')
      allow(has_many_fetcher).to receive(:fetch).with(a: 1, b: 2).and_return(result)

      Trello::AssociationBuilder::HasMany.build(FakeBoard, 'boards', {})
      expect(fake_board.boards(a: 1, b: 2)).to eq(result)
    end
  end

end
