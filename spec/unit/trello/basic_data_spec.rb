require 'spec_helper'

RSpec.describe Trello::BasicData do

  describe '.register_attributes' do
    around do |example|
      module Trello
        class FakeCard < BasicData
        end
      end

      example.run

      Trello.send(:remove_const, 'FakeCard')
    end

    it 'call execute on RegisterAttributes' do
      expect(Trello::RegisterAttributes)
        .to receive(:execute)
        .with(Trello::FakeCard, [:id, :name, :desc], [:id, :name])

      Trello::FakeCard.class_eval do
        register_attributes :id, :name, :desc, readonly: [:id, :name]
      end
    end
  end

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
