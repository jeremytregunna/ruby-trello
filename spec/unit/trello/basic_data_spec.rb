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

    before { allow(Trello::FakeCard).to receive(:register_attrs) }

    it 'call instance_eval on a schema instance' do
      expect_any_instance_of(Trello::Schema).to receive(:instance_eval)

      Trello::FakeCard.class_eval do
        schema do
          'PlaceHolder'
        end
      end
    end

    it 'call register_attrs on model' do
      allow_any_instance_of(Trello::Schema).to receive(:instance_eval)
      expect(Trello::FakeCard).to receive(:register_attrs)

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

  describe '.register_attrs' do
    around do |example|
      module Trello
        class FakeCard < BasicData
        end
      end
  
      example.run
  
      Trello.send(:remove_const, 'FakeCard')
    end
  
    let(:attribute_1) { double('attribute 1') }
    let(:attribute_2) { double('attribute 2') }
    let(:attribute_3) { double('attribute 3') }
  
    let(:schema) { double('Trello::Schema',
      attrs: {
        name: attribute_1,
        desc: attribute_2,
        url: attribute_3
      }
    ) }
  
    before { allow(Trello::FakeCard).to receive(:schema).and_return(schema) }
  
    it 'will call register on each attributes' do
      expect(attribute_1).to receive(:register).with(Trello::FakeCard)
      expect(attribute_2).to receive(:register).with(Trello::FakeCard)
      expect(attribute_3).to receive(:register).with(Trello::FakeCard)
  
      Trello::FakeCard.register_attrs
    end
  end

  describe '.many' do
    let(:association_name) { 'cards' }
    let(:association_options) { { test: 'test' } }

    it 'call build on AssociationBuilder::HasMany' do
      expect(Trello::AssociationBuilder::HasMany)
        .to receive(:build)
        .with(Trello::BasicData, association_name, association_options)

      Trello::BasicData.many(association_name, association_options)
    end
  end

  describe '.one' do
    let(:association_name) { 'card' }
    let(:association_options) { { path: 'test' } }

    it 'call build on AssociationBuilder::HasOne' do
      expect(Trello::AssociationBuilder::HasOne)
        .to receive(:build)
        .with(Trello::BasicData, association_name, association_options)

      Trello::BasicData.one(association_name, association_options)
    end
  end

end
