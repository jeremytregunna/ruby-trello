
require 'spec_helper'

RSpec.describe 'Trello::Schema::Attribute::BoardPref' do

  let(:attribute) { Trello::Schema::Attribute::BoardPref.new(name: name, options: options, serializer: serializer) }

  describe '#build_attributes' do
    let(:name) { :visibility_level }
    let(:options) { { remote_key: :permissionLevel } }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:deserialize)
        .with('org', default)
        .and_return('org')
    end

    let(:build_attributes) { attribute.build_attributes(params, attributes) }
    let(:attributes) { { name: 'John' } }

    context 'when target key in params is string' do
      let(:params) { { 'prefs' => { 'permissionLevel' => 'org' } } }

      it 'fetch and deserialize that value and set to attributes with symbolize name' do
        expect(build_attributes).to eq({ name: 'John', visibility_level: 'org' })
      end
    end

    context 'when target key in params is symbol' do
      let(:params) { { visibility_level: 'org' } }

      it 'get and deserialize that value and set to attributes with symbolize name' do
        expect(build_attributes).to eq({ name: 'John', visibility_level: 'org' })
      end
    end
  end

  describe '#build_payload_for_create' do
    let(:name) { :visibility_level }
    let(:options) { { remote_key: :permissionLevel } }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with('org')
        .and_return('org')
    end

    let(:build_attributes) { attribute.build_payload_for_create(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }


    context 'when attribute is for action create' do

      context 'when attribute value is nil' do
        let(:attributes) { { visibility_level: nil } }

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
        let(:attributes) { { visibility_level: 'org' } }

        it 'get and serialize that value and set to payload with stringify name' do
          expect(build_attributes).to eq({ 'name' => 'John', 'prefs_permissionLevel' => 'org' })
        end
      end
    end

    context 'when attribute is not for action create' do
      let(:options) { { remote_key: :permissionLevel, update_only: true } }
      let(:attributes) { { visibility_level: 'org' } }

      it "won't put it in payload" do
        expect(build_attributes).to eq({ 'name' => 'John' })
      end
    end
  end

  describe '#build_payload_for_update' do
    let(:name) { :visibility_level }
    let(:serializer) { double('serializer') }
    let(:default) { nil }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with('org')
        .and_return('org')
    end

    let(:build_attributes) { attribute.build_payload_for_update(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }

    context 'when attribute is for action create' do
      let(:options) { { remote_key: :permissionLevel } }

      context 'when attributes does not contain the attribute key' do
        let(:attributes) { {} }

        it "won't put it in payload" do
          expect(build_attributes).to eq({ 'name' => 'John' })
        end
      end

      context 'when attribute value is normal' do
        let(:attributes) { { visibility_level: 'org' } }

        it 'get and serialize that value and set to payload with stringify name' do
          expect(build_attributes).to eq({ 'name' => 'John', 'prefs/permissionLevel' => 'org' })
        end
      end
    end

    context 'when attribute is not for action update' do
      let(:options) { { remote_key: :permissionLevel, create_only: true } }
      let(:attributes) { { visibility_level: 'org' } }

      it "won't put it in payload" do
        expect(build_attributes).to eq({ 'name' => 'John' })
      end
    end
  end

end
