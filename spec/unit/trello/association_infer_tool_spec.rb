require 'spec_helper'

RSpec.describe Trello::AssociationInferTool do

  describe '.infer_restful_resource_on_class' do
    let(:infer) { lambda { |klass|
      Trello::AssociationInferTool.infer_restful_resource_on_class(klass)
     } }

    it 'can infer boards on Trello::Board' do
      expect(infer.call(Trello::Board)).to eq('boards')
    end

    it 'can infer cards on Trello::Card' do
      expect(infer.call(Trello::Card)).to eq('cards')
    end

    it 'can infer members on Trello::Member' do
      expect(infer.call(Trello::Member)).to eq('members')
    end
  end

  describe '.infer_class_on_name' do
    let(:infer) { lambda { |association_name|
      Trello::AssociationInferTool.infer_class_on_name(association_name)
     } }

    it 'can infer Trello::Board on boards' do
      expect(infer.call('boards')).to eq(Trello::Board)
    end

    it 'can infer Trello::Card on cards' do
      expect(infer.call('cards')).to eq(Trello::Card)
    end

    it 'can infer Trello::Member on members' do
      expect(infer.call('members')).to eq(Trello::Member)
    end
  end

end
