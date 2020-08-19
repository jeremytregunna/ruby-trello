require 'spec_helper'

RSpec.describe Trello::Schema do

  describe '#attribute' do
    let(:schema) { Trello::Schema.new }

    it 'record attribute to attrs' do
      attribute_1 = double('Trello::Schema::Attribute::Default')
      attribute_2 = double('Trello::Schema::Attribute::Default')

      expect(Trello::Schema::AttributeBuilder).to receive(:build).with(:id, readonly: true).and_return(attribute_1)
      expect(Trello::Schema::AttributeBuilder).to receive(:build).with(:name, {}).and_return(attribute_2)

      schema.attribute(:id, readonly: true)
      schema.attribute(:name)

      expect(schema.attrs).to be_a(Hash)
      expect(schema.attrs.count).to eq(2)
      expect(schema.attrs[:id]).to eq(attribute_1)
      expect(schema.attrs[:name]).to eq(attribute_2)
    end
  end

end
