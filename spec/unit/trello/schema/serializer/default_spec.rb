require 'spec_helper'

RSpec.describe 'Trello::Schema::Serializer::Default' do

  describe '.serialize' do
    it 'directly return the value' do
      expect(Trello::Schema::Serializer::Default.serialize('John')).to eq('John')
    end
  end

  describe '.deserialize' do
    it 'directly return the value' do
      expect(Trello::Schema::Serializer::Default.deserialize('John', nil)).to eq('John')
      expect(Trello::Schema::Serializer::Default.deserialize(nil, 'John')).to eq('John')
    end
  end

end
