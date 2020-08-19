require 'spec_helper'

RSpec.describe 'Trello::Schema::Serializer::Time' do

  describe '.serialize' do
    it 'parse the time to string with format like: 2020-01-01T00:00:00.000Z' do
      expect(Trello::Schema::Serializer::Time.serialize(Time.new(2020, 4, 13, 23, 12, 59))).to eq('2020-04-13T23:12:59.000Z')
    end
  end

  describe '.deserialize' do
    context 'when pass in time string' do
      it 'parset it to a time' do
        expect(Trello::Schema::Serializer::Time.deserialize('2020-04-13T23:12:59.000Z', nil)).to eq(Time.new(2020, 4, 13, 23, 12, 59))
      end
    end

    context 'when pass in a time' do
      it 'return the time' do
        expect(Trello::Schema::Serializer::Time.deserialize(Time.new(2020, 4, 13, 23, 12, 59), nil)).to eq(Time.new(2020, 4, 13, 23, 12, 59))
      end
    end

    context 'when pass in a object respond to :to_time. i.e. Date, DateTime ...' do
      it 'convert it to time' do
        expect(Trello::Schema::Serializer::Time.deserialize(Date.new(2020, 4, 13), nil)).to eq(Time.new(2020, 4, 13))
      end
    end

    context 'when pass in a invalid value' do
      it 'return the default value' do
        expect(Trello::Schema::Serializer::Time.deserialize('abc', nil)).to eq(nil)
        expect(Trello::Schema::Serializer::Time.deserialize('abc', Time.new(2020, 1, 1))).to eq(Time.new(2020, 1, 1))
        expect(Trello::Schema::Serializer::Time.deserialize(nil, Time.new(2020, 1, 1))).to eq(Time.new(2020, 1, 1))
      end
    end
  end

end
