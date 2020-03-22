require 'spec_helper'

RSpec.describe Trello::AssociationFetcher::HasMany::Params do

  let(:params) { Trello::AssociationFetcher::HasMany::Params.new(
    association_owner: association_owner,
    association_name: association_name,
    association_options: association_options,
    filter: filter
  ) }

  let(:association_owner) { double('owner', id: 1) }
  let(:association_name) { 'cards' }
  let(:association_options) { { filter: :all } }
  let(:filter) { { a: 1 } }

  describe '.association_class' do
    context 'when explicit set :via in association_options' do
      let(:association_options) { { via: Trello::Board } }

      it 'return the value under the :via key' do
        expect(params.association_class).to eq(Trello::Board)
      end
    end

    context 'when does not set :via in association_options' do
      before do
        allow(Trello::AssociationInferTool)
          .to receive(:infer_class_on_name)
          .with(association_name)
          .and_return(Trello::Card)
      end

      it 'return association_class use AssociationInferTool' do
        expect(params.association_class).to eq(Trello::Card)
      end
    end
  end

  describe '.association_owner' do
    it 'return association_owner directly' do
      expect(params.association_owner).to eq(association_owner)
    end
  end

  describe '.fetch_path' do
    context 'when explicit set :in, :path in association_options' do
      let(:association_options) { { in: 'boards', path: 'cards' } }

      it 'use them to generate fetch_path - formula: ":in/owner_id/:path"' do
        expect(params.fetch_path).to eq('/boards/1/cards')
      end
    end

    context 'when does not set :in, :path in association_options' do
      let(:association_owner) { double('owner', id: 1, class: Trello::Member) }
      before do
        allow(Trello::AssociationInferTool)
          .to receive(:infer_restful_resource_on_class)
          .with(Trello::Member)
          .and_return('members')
      end

      it 'will generate fetch_path use AssociationInferTool' do
        expect(params.fetch_path).to eq('/members/1/cards')
      end
    end
  end

  describe '.filter_params' do
    context 'when filter and default_filer are both nil' do
      let(:association_options) { nil }
      let(:filter) { nil }

      it 'return a empty hash' do
        expect(params.filter_params).to eq({})
      end
    end

    context 'when filter is nil' do
      let(:association_options) { { filter: :all } }
      let(:filter) { nil }

      it 'return default filter' do
        expect(params.filter_params).to eq({ filter: :all })
      end
    end

    context 'when default filter is nil' do
      let(:association_options) { nil }
      let(:filter) { { a: 1 } }

      it 'return filter' do
        expect(params.filter_params).to eq({ a: 1 })
      end
    end

    context 'when both filter and default_filter exists' do
      let(:association_options) { { filter: :all } }
      let(:filter) { { a: 1, filter: :open } }

      it 'return the result from merge filter on default_filter' do
        expect(params.filter_params).to eq({a: 1, filter: :open})
      end
    end
  end
end
