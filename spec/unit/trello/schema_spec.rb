require 'spec_helper'

RSpec.describe Trello::Schema do

  describe '#attribute' do
    let(:schema) { Trello::Schema.new }

    it 'record attribute to attrs' do
      schema.attribute(:id, readonly: true)
      schema.attribute(:name)

      expect(schema.attrs).to be_a(Hash)
      expect(schema.attrs.count).to eq(2)
      expect(schema.attrs[:id]).to be_a(Trello::Schema::Attribute)
      expect(schema.attrs[:id].name).to eq(:id)
      expect(schema.attrs[:name]).to be_a(Trello::Schema::Attribute)
      expect(schema.attrs[:name].name).to eq(:name)
    end
  end

end
