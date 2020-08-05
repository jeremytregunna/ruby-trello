require 'spec_helper'

RSpec.describe 'Trello::Schema::Attribute::Default' do

  let(:attribute) { Trello::Schema::Attribute::Default.new(name: name, options: options, serializer: serializer) }

  describe '#build_attributes' do
    let(:name) { :date_create_utc }
    let(:options) { { remote_key: 'dateCreateUTC' } }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:deserialize)
        .with(raw_value, default)
        .and_return(deserialize_result)
    end

    let(:build_attributes) { attribute.build_attributes(params, attributes) }
    let(:attributes) { { name: 'John' } }

    context 'when target key in params is string' do
      let(:raw_value) { '2020-02-20 00:00:00' }
      let(:deserialize_result) { Time.new(2020, 2, 20) }
      let(:params) { { 'date_create_utc' => raw_value } }

      it 'get and deserialize that value and set to attributes' do
        expect(build_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: Time.new(2020, 2, 20) }
        )
      end
    end

    context 'when target key in params is symbol' do
      let(:raw_value) { '2020-02-20 00:00:00' }
      let(:deserialize_result) { Time.new(2020, 2, 20) }
      let(:params) { { date_create_utc: raw_value } }

      it 'get and deserialize that value and set to attributes' do
        expect(build_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: Time.new(2020, 2, 20) }
        )
      end
    end

    context 'when value under remote_key is nil' do
      let(:raw_value) { nil }
      let(:deserialize_result) { nil }
      let(:params) { { 'dateCreateUTC': raw_value } }

      it 'get and deserialize that value and set to attributes' do
        expect(build_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: nil }
        )
      end
    end

    context 'when value under name key is nil' do
      let(:raw_value) { nil }
      let(:deserialize_result) { nil }
      let(:params) { { date_create_utc: raw_value } }

      it 'get and deserialize that value and set to attributes' do
        expect(build_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: nil }
        )
      end
    end

    context 'when value under remote_key is false' do
      let(:raw_value) { false }
      let(:deserialize_result) { false }
      let(:params) { { 'dateCreateUTC': raw_value } }

      it 'get and deserialize that value and set to attributes' do
        expect(build_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: false }
        )
      end
    end
  end


  describe '#build_pending_update_attributes' do
    let(:name) { :date_create_utc }
    let(:options) { { remote_key: 'dateCreateUTC' } }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:deserialize)
        .with(raw_value, default)
        .and_return(deserialize_result)
    end

    let(:build_pending_update_attributes) { attribute.build_pending_update_attributes(params, attributes) }
    let(:attributes) { { name: 'John' } }

    context 'when remote_key and target key is missing' do
      let(:raw_value) { false }
      let(:deserialize_result) { false }
      let(:params) { {} }

      it "won't set any value to pending update attributes" do
        expect(build_pending_update_attributes).to match_hash_with_indifferent_access({ name: 'John' })
      end
    end

    context 'when remote_key exists' do
      let(:raw_value) { false }
      let(:deserialize_result) { false }
      let(:params) { { 'dateCreateUTC': raw_value } }

      it 'will set the value to pending update attributes' do
        expect(build_pending_update_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: raw_value }
        )
      end
    end

    context 'when target key exists' do
      let(:raw_value) { false }
      let(:deserialize_result) { false }
      let(:params) { { date_create_utc: raw_value } }

      it 'will set the value to pending update attributes' do
        expect(build_pending_update_attributes).to match_hash_with_indifferent_access(
          { name: 'John', date_create_utc: raw_value }
        )
      end
    end
  end


  describe '#build_payload_for_create' do
    let(:name) { :date_create_utc }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with(Time.new(2020, 2, 20))
        .and_return('2020-02-20 00:00:00')
    end

    let(:build_attributes) { attribute.build_payload_for_create(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }


    context 'when attribute is for action create' do
      let(:options) { {} }

      context 'when attribute value is nil' do
        let(:attributes) { { date_create_utc: nil } }

        it "won't put it in payload" do
          expect(build_attributes).to eq({ 'name' => 'John' })
        end
      end

      context 'when attributes does not contain the attribute key' do
        let(:attributes) { {} }

        it "won't put it in payload" do
          expect(build_attributes).to eq({ 'name' => 'John' })
        end
      end

      context 'when attribute value is normal' do
        let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

        it 'get and serialize that value and set to payload with stringify name' do
          expect(build_attributes).to eq({ 'name' => 'John', 'date_create_utc' => '2020-02-20 00:00:00' })
        end
      end
    end

    context 'when attribute is not for action create' do
      let(:options) { { update_only: true } }
      let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

      it "won't put it in payload" do
        expect(build_attributes).to eq({ 'name' => 'John' })
      end
    end
  end

  describe '#build_payload_for_update' do
    let(:name) { :date_create_utc }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with(Time.new(2020, 2, 20))
        .and_return('2020-02-20 00:00:00')
    end

    let(:build_attributes) { attribute.build_payload_for_update(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }

    context 'when attribute is for action create' do
      let(:options) { {} }

      context 'when attributes does not contain the attribute key' do
        let(:attributes) { {} }

        it "won't put it in payload" do
          expect(build_attributes).to eq({ 'name' => 'John' })
        end
      end

      context 'when attribute value is normal' do
        let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

        it 'get and serialize that value and set to payload with stringify name' do
          expect(build_attributes).to eq({ 'name' => 'John', 'date_create_utc' => '2020-02-20 00:00:00' })
        end
      end
    end

    context 'when attribute is not for action create' do
      let(:options) { { create_only: true } }
      let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

      it "won't put it in payload" do
        expect(build_attributes).to eq({ 'name' => 'John' })
      end
    end
  end

end
