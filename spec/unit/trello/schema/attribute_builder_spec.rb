require 'spec_helper'

RSpec.describe Trello::Schema::AttributeBuilder do

  describe '.build' do
    context 'when does not pass class_name and serializer' do
      let(:build_attribute) { Trello::Schema::AttributeBuilder.build(:name, { readonly: true }) }
      let(:attribute) { double('attribute') }

      it 'use Schema::Attribute::Default to initialize with Schema::Serializer::Default' do
        expect(Schema::Attribute::Default)
          .to receive(:new)
          .with(name: :name, options: { readonly: true }, serializer: Schema::Serializer::Default)
          .and_return(attribute)

        expect(build_attribute).to eq(attribute)
      end
    end

    context 'when does pass class_name and serializer' do
      let(:build_attribute) { Trello::Schema::AttributeBuilder.build(:name, { readonly: true, class_name: 'CustomAttribute', serializer: 'CustomSerializer' }) }
      let(:attribute) { double('attribute') }

      around do |example|
        module Trello
          class Schema
            module Attribute
              class CustomAttribute
              end
            end
            module Serializer
              class CustomSerializer
              end
            end
          end
        end

        example.run

        Trello::Schema::Attribute.send(:remove_const, 'CustomAttribute')
        Trello::Schema::Serializer.send(:remove_const, 'CustomSerializer')
      end

      it 'use passin class to initializer with passin serializer' do
        expect(Schema::Attribute::CustomAttribute)
          .to receive(:new)
          .with(name: :name, options: { readonly: true }, serializer: Schema::Serializer::CustomSerializer)
          .and_return(attribute)

        expect(build_attribute).to eq(attribute)
      end
    end
  end

end
