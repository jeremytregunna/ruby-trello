require 'spec_helper'

RSpec.describe Trello::Schema::AttributeRegistration do

  around do |example|
    module Trello
      class FakeBoard < BasicData
        def initialize; end
      end
    end

    example.run

    Trello.send(:remove_const, 'FakeBoard')
  end

  let(:attribute) { Trello::Schema::Attribute::Base.new(
    name: name,
    options: options,
    serializer: serializer
  ) }

  context 'when it is a writable attribute' do
    let(:name) { :name }
    let(:serializer) { double('serializer') }
    let(:options) { nil }

    it 'create getter method for the attribute' do
      Trello::Schema::AttributeRegistration.register(Trello::FakeBoard, attribute)

      expect(Trello::FakeBoard.new).to respond_to(:name)
    end

    it 'create setter method for the attribute' do
      Trello::Schema::AttributeRegistration.register(Trello::FakeBoard, attribute)

      expect(Trello::FakeBoard.new).to respond_to(:name=)
    end
  end

  context 'when it is a readonly attribute' do
    let(:name) { :name }
    let(:serializer) { double('serializer') }
    let(:options) { { readonly: true } }

    it 'create getter method for the attribute' do
      Trello::Schema::AttributeRegistration.register(Trello::FakeBoard, attribute)

      expect(Trello::FakeBoard.new).to respond_to(:name)
    end

    it "won't create setter method for the attribute" do
      Trello::Schema::AttributeRegistration.register(Trello::FakeBoard, attribute)

      expect(Trello::FakeBoard.new).not_to respond_to(:name=)
    end
  end

end
