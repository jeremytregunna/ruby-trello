require 'spec_helper'

RSpec.describe 'Trello::Schema::Attribute::Default' do

  let(:attribute) { Trello::Schema::Attribute::Default.new(name: name, options: options, serializer: serializer) }

  describe '#name' do
    let(:options) { nil }
    let(:serializer) { Trello::Schema::Serializer::Default }

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
    let(:serializer) { Trello::Schema::Serializer::Default }

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
    let(:serializer) { Trello::Schema::Serializer::Default }

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
    let(:serializer) { Trello::Schema::Serializer::Default }

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

  describe '#build_payload' do
    let(:name) { :date_create_utc }
    let(:options) { {} }
    let(:serializer) { double('serializer') }

    before do
      allow(serializer)
        .to receive(:serialize)
        .with(Time.new(2020, 2, 20))
        .and_return('2020-02-20 00:00:00')
    end

    let(:build_attributes) { attribute.build_payload(attributes, payload) }
    let(:payload) { { 'name' => 'John' } }
    let(:attributes) { { date_create_utc: Time.new(2020, 2, 20) } }

    it 'get and serialize that value and set to payload with stringify name' do
      expect(build_attributes).to eq({ 'name' => 'John', 'date_create_utc' => '2020-02-20 00:00:00' })
    end
  end

  describe '#remote_key' do
    let(:name) { :date_create_utc }
    let(:serializer) { double('serializer') }

    context 'when explict pass in remote_key' do
      let(:options) { { remote_key: 'dateCreateUTC' } }

      it 'directly return the remote_key' do
        expect(attribute.remote_key).to eq('dateCreateUTC')
      end
    end

    context 'when does not explict pass in remote_key' do
      let(:options) { {} }

      it 'return the stringify name' do
        expect(attribute.remote_key).to eq('date_create_utc')
      end
    end
  end

end
