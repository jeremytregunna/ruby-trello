require 'spec_helper'

RSpec.describe Trello::BasicData do

  describe '.schema' do
    around do |example|
      module Trello
        class FakeCard < BasicData
        end
      end

      example.run

      Trello.send(:remove_const, 'FakeCard')
    end

    it 'call instance_eval on a schema instance' do
      expect_any_instance_of(Trello::Schema).to receive(:instance_eval)

      Trello::FakeCard.class_eval do
        schema do
          'PlaceHolder'
        end
      end
    end

    it 'return the @schema if it exist' do
      Trello::FakeCard.class_eval do
        schema do
          'PlaceHolder'
        end
      end

      expect(Trello::Schema).not_to receive(:new)
      expect(Trello::FakeCard.schema).to be_a(Trello::Schema)
    end
  end

  describe '.register_attr' do
    around do |example|
      module Trello
        class FakeCard < BasicData
        end
      end

      example.run

      Trello.send(:remove_const, 'FakeCard')
    end

    it 'call execute on RegisterAttr' do
      expect(Trello::RegisterAttr)
        .to receive(:execute)
        .with(Trello::FakeCard,
          :last_activity_date,
          readonly: true,
          serialize: :time,
          remote_key: 'dateLastActivity'
        )

      Trello::FakeCard.class_eval do
        register_attr :last_activity_date,
                      readonly: true,
                      serialize: :time,
                      remote_key: 'dateLastActivity'
      end
    end
  end

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
        .with(Trello::FakeCard,
          names: [:id, :name, :desc],
          readonly: [:id, :name],
          create_only: [:enable],
          update_only: [:color]
        )

      Trello::FakeCard.class_eval do
        register_attributes :id, :name, :desc,
          readonly: [:id, :name],
          create_only: [:enable],
          update_only: [:color]
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
