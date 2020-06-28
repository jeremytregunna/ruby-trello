require 'spec_helper'

RSpec.describe Trello::RegisterAttr do

  describe '.execute' do
    around do |example|
      module Trello
        class FakeBoard < BasicData
        end
      end

      example.run

      Trello.send(:remove_const, 'FakeBoard')
    end

    it 'create getter method for the attribute' do
      Trello::FakeBoard.class_eval do
        register_attr :name

        def initialize; end
      end

      expect(Trello::FakeBoard.new).to respond_to(:name)
    end

    it 'create setter method if the attribute is writable' do
      Trello::FakeBoard.class_eval do
        register_attr :name

        def initialize; end
      end

      expect(Trello::FakeBoard.new).to respond_to(:name=)
    end

    it "won't create setter method if the attribute is readonly" do
      Trello::FakeBoard.class_eval do
        register_attr :name, readonly: true

        def initialize; end
      end

      expect(Trello::FakeBoard.new).not_to respond_to(:name=)
    end
  end

end
