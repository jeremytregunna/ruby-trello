require 'spec_helper'

RSpec.describe Trello::Attribute do

  let(:attribute) { Trello::Attribute.new(name, options) }

  describe '#core' do
    let(:name) { :description }

    context 'when does not explict pass core class name' do
      let(:options) { nil }

      it 'return Trello::Attribute::Core::Default' do
        expect(attribute.core).to eq(Trello::Attribute::Core::Default)
      end
    end

    context 'when explict pass core class name' do
      let(:options) { { core: 'TestCore' } }

      around do |example|
        module Trello
          class Attribute
            module Core
              class TestCore
              end
            end
          end
        end

        example.run

        Trello::Attribute::Core.send(:remove_const, 'TestCore')
      end

      it 'return Trello::Attribute::Core::#{serializer}' do
        expect(attribute.core).to eq(Trello::Attribute::Core::TestCore)
      end
    end
  end

  describe '#serializer' do
    let(:name) { :description }

    context 'when does not explict pass serialize parameter' do
      let(:options) { nil }

      it 'return Trello::Attribute::Serializer::Default' do
        expect(attribute.serializer).to eq(Trello::Attribute::Serializer::Default)
      end
    end

    context 'when explict pass serialize parameter' do
      let(:options) { { serializer: 'TestSerializer' } }

      around do |example|
        module Trello
          class Attribute
            module Serializer
              class TestSerializer
              end
            end
          end
        end

        example.run

        Trello::Attribute::Serializer.send(:remove_const, 'TestSerializer')
      end

      it 'return Trello::Attribute::Serializer::#{serializer}' do
        expect(attribute.serializer).to eq(Trello::Attribute::Serializer::TestSerializer)
      end
    end
  end

  describe '#name' do
    let(:options) { nil }

    context 'when name is a symbol' do
      let(:name) { :name }

      it 'directly return the name' do
        expect(attribute.name).to eq(:name)
      end
    end

    context 'when name is a string' do
      let(:name) { 'name' }

      it 'directly return the symbolize name' do
        expect(attribute.name).to eq(:name)
      end
    end
  end

  describe '#readlonly?' do
    let(:name) { :name }

    context 'when does not explict pass readonly parameter' do
      let(:options) { nil }

      it 'return false' do
        expect(attribute.readonly?).to eq(false)
      end
    end

    context 'when does explict pass readonly parameter' do
      context 'and readonly is true' do
        let(:options) { { readonly: true } }

        it 'return true' do
          expect(attribute.readonly?).to eq(true)
        end
      end

      context 'and readonly is false' do
        let(:options) { { readonly: false } }

        it 'return false' do
          expect(attribute.readonly?).to eq(false)
        end
      end

      context 'and readonly is not a boolean' do
        let(:options) { { readonly: 'other' } }

        it 'return false' do
          expect(attribute.readonly?).to eq(false)
        end
      end
    end
  end

  describe '#update_only?' do
    let(:name) { :name }

    context 'when does not explict pass update_only parameter' do
      let(:options) { nil }

      it 'return false' do
        expect(attribute.update_only?).to eq(false)
      end
    end

    context 'when does explict pass update_only parameter' do
      context 'and update_only is true' do
        let(:options) { { update_only: true } }

        it 'return true' do
          expect(attribute.update_only?).to eq(true)
        end
      end

      context 'and update_only is false' do
        let(:options) { { update_only: false } }

        it 'return false' do
          expect(attribute.update_only?).to eq(false)
        end
      end

      context 'and update_only is not a boolean' do
        let(:options) { { update_only: 'other' } }

        it 'return false' do
          expect(attribute.update_only?).to eq(false)
        end
      end
    end
  end

  describe '#create_only?' do
    let(:name) { :name }

    context 'when does not explict pass create_only parameter' do
      let(:options) { nil }

      it 'return false' do
        expect(attribute.create_only?).to eq(false)
      end
    end

    context 'when does explict pass create_only parameter' do
      context 'and create_only is true' do
        let(:options) { { create_only: true } }

        it 'return true' do
          expect(attribute.create_only?).to eq(true)
        end
      end

      context 'and create_only is false' do
        let(:options) { { create_only: false } }

        it 'return false' do
          expect(attribute.create_only?).to eq(false)
        end
      end

      context 'and create_only is not a boolean' do
        let(:options) { { create_only: 'other' } }

        it 'return false' do
          expect(attribute.create_only?).to eq(false)
        end
      end
    end
  end

  describe '#build_attributes' do
    let(:name) { :description }
    let(:options) { nil }
    let(:custom_core) { double('Trello::Attribute::Core::Custom') }
    let(:custom_serializer) { double('Trello::Attribute::Serializer::Custom') }
    let(:passin_params) { { 'name' => 'John', 'description' => 'desc...' } }
    let(:passin_attributes) { { name: 'John' } }

    before do
      allow(attribute).to receive(:core).and_return(custom_core)
      allow(attribute).to receive(:serializer).and_return(custom_serializer)
    end

    it 'generate attbiutes by call custom_core.build_attributes' do
      expect(custom_core).to receive(:build_attributes).with(
        params: passin_params,
        attributes: passin_attributes,
        serializer: custom_serializer
      ).and_return({ name: 'John', description: 'desc...' })

      attributes = attribute.build_attributes(passin_params, passin_attributes)
      expect(attributes).to eq({ name: 'John', description: 'desc...' })
    end
  end

end
