require 'spec_helper'

RSpec.describe Trello::BasicData do

  describe '.many' do
    let(:association_name) { 'cards' }
    let(:association_options) { { test: 'test' } }

    it 'call build on AssociationBuilder::HasMany' do
      expect(AssociationBuilder::HasMany)
        .to receive(:build)
        .with(Trello::BasicData, association_name, association_options)

      Trello::BasicData.many(association_name, association_options)
    end
  end

  describe '.one' do
    let(:association_name) { 'card' }
    let(:association_options) { { path: 'test' } }

    it 'call build on AssociationBuilder::HasOne' do
      expect(AssociationBuilder::HasOne)
        .to receive(:build)
        .with(Trello::BasicData, association_name, association_options)

      Trello::BasicData.one(association_name, association_options)
    end
  end

end
