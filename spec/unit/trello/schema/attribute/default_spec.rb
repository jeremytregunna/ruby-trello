require 'spec_helper'

RSpec.describe 'Trello::Schema::Attribute::Default' do

  let(:attribute) { Trello::Schema::Attribute::Default.new(name: name, options: options, serializer: serializer) }

  describe '#build_attributes' do
    let(:name) { :date_create_utc }
    let(:options) { {} }
    let(:serializer) { double('serializer') }

    before do
      allow(serializer)
        .to receive(:deserialize)
        .with('2020-02-20 00:00:00')
        .and_return(Time.new(2020, 2, 20))
    end

    let(:build_attributes) { attribute.build_attributes(params, attributes) }
    let(:attributes) { { name: 'John' } }

    context 'when target key in params is string' do
      let(:params) { { 'date_create_utc' => '2020-02-20 00:00:00' } }

      it 'get and deserialize that value and set to attributes with symbolize name' do
        expect(build_attributes).to eq({ name: 'John', date_create_utc: Time.new(2020, 2, 20) })
      end
    end

    context 'when target key in params is symbol' do
      let(:params) { { date_create_utc: '2020-02-20 00:00:00' } }

      it 'get and deserialize that value and set to attributes with symbolize name' do
        expect(build_attributes).to eq({ name: 'John', date_create_utc: Time.new(2020, 2, 20) })
      end
    end
  end

  describe '#build_payload_for_create' do
    let(:name) { :date_create_utc }
    let(:options) { {} }
    let(:serializer) { double('serializer') }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with(Time.new(2020, 2, 20))
        .and_return('2020-02-20 00:00:00')
    end

    let(:build_attributes) { attribute.build_payload_for_create(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }
    let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

    it 'get and serialize that value and set to payload with stringify name' do
      expect(build_attributes).to eq({ 'name' => 'John', 'date_create_utc' => '2020-02-20 00:00:00' })
    end
  end

  describe '#build_payload_for_update' do
    let(:name) { :date_create_utc }
    let(:options) { {} }
    let(:serializer) { double('serializer') }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with(Time.new(2020, 2, 20))
        .and_return('2020-02-20 00:00:00')
    end

    let(:build_attributes) { attribute.build_payload_for_update(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }
    let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

    it 'get and serialize that value and set to payload with stringify name' do
      expect(build_attributes).to eq({ 'name' => 'John', 'date_create_utc' => '2020-02-20 00:00:00' })
    end
  end

end
