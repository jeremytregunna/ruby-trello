require 'spec_helper'

RSpec.describe Trello::AssociationFetcher::HasOne::Params do

        # association_owner
        # association_restful_name
        # association_restful_id
        # association_class

        # opts = options.dup
        # klass   = opts.delete(:via) || Trello.const_get(name.to_s.camelize)
        # ident   = opts.delete(:using) || :id
        # path    = opts.delete(:path)
  let(:params) { Trello::AssociationFetcher::HasOne::Params.new(
    association_owner: association_owner,
    association_name: association_name,
    association_options: association_options,
  )}

  let(:association_owner) { double('owner', id: 1, organization_id: 9) }
  let(:association_name) { 'organization' }
  let(:association_options) { { using: :organization_id } }

  describe 'association_class' do
    context 'when explicit set :via in association_options' do
      let(:association_options) { { via: Trello::Organization } }

      it 'return the value under the :via key' do
        expect(params.association_class).to eq(Trello::Organization)
      end
    end

    context 'when does not set :via in association_options' do
      before do
        allow(Trello::AssociationInferTool)
          .to receive(:infer_class_on_name)
          .with(association_name)
          .and_return(Trello::Organization)
      end

      it 'return association_class use AssociationInferTool' do
        expect(params.association_class).to eq(Trello::Organization)
      end
    end
  end

  describe 'association_owner' do
    it 'return association_owner directly' do
      expect(params.association_owner).to eq(association_owner)
    end
  end

  describe 'association_restful_name' do
    context 'when explicit set :path in association_options' do
      let(:association_options) { { path: :organizations } }

      it 'return :path directly' do
        expect(params.association_restful_name).to eq('organizations')
      end
    end

    context 'when does not set :path in association_options' do
      let(:association_options) { {} }

      it 'return nil' do
        expect(params.association_restful_name).to eq(nil)
      end
    end
  end

  describe 'association_restful_id' do
    context 'when explicit set :using in association_options' do
      let(:association_options) { { using: :organization_id } }

      it 'return the result from association_owner.<using> directly' do
        expect(params.association_restful_id).to eq(9)
      end
    end

    context 'when does not set :using in association_options' do
      let(:association_options) { {} }

      it 'return the result from association_owner.id directly' do
        expect(params.association_restful_id).to eq(1)
      end
    end
  end


end
