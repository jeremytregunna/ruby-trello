require 'spec_helper'

RSpec.describe 'Trello::BasicData.register_attributes' do

  around do |example|
    module Trello
      class FakeBoard < BasicData
      end
    end

    example.run

    Trello.send(:remove_const, 'FakeBoard')
  end

  describe 'record attributes' do
    before do
      Trello::FakeBoard.class_eval do
        register_attributes :id,
                            :name,
                            :description,
                            readonly: [:id],
                            create_only: [:enable],
                            update_only: [:color]

        def initialize(fields={})
        end
      end
    end

    it 'will record all writable attributes' do
      expect(Trello::FakeBoard.writable_attributes).to eq([:name, :description])
      expect(Trello::FakeBoard.new.writable_attributes).to eq([:name, :description])
    end

    it 'will record all read-only attributes' do
      expect(Trello::FakeBoard.readonly_attributes).to eq([:id])
      expect(Trello::FakeBoard.new.readonly_attributes).to eq([:id])
    end

    it 'will record all create-only attributes' do
      expect(Trello::FakeBoard.create_only_attributes).to eq([:enable])
      expect(Trello::FakeBoard.new.create_only_attributes).to eq([:enable])
    end

    it 'will record all update-only attributes' do
      expect(Trello::FakeBoard.update_only_attributes).to eq([:color])
      expect(Trello::FakeBoard.new.update_only_attributes).to eq([:color])
    end
  end

  describe 'create getter and setter methods' do
    context 'when register attributes are all writable' do
      before do
        Trello::FakeBoard.class_eval do
          register_attributes :id, :name, :description

          def initialize(fields={})
            attributes[:id] = fields[:id]
            attributes[:name] = fields[:name]
            attributes[:description] = fields[:description]
          end
        end
      end

      it 'create getter method for all attributes' do
        expect(Trello::FakeBoard.new).to respond_to(:id, :name, :description)
      end

      it 'create setting method for all attributes' do
        expect(Trello::FakeBoard.new).to respond_to(:id=, :name=, :description=)
      end

      it 'any attributes changes will caused the record being marked as changed' do
        fake_board = Trello::FakeBoard.new(id: 1, name: 'test')
        expect(fake_board.changed?).to eq(false)
        fake_board.name = 'TEST'
        expect(fake_board.changed?).to eq(true)
      end
    end

    context 'when register attributes are partial read-only' do
      before do
        Trello::FakeBoard.class_eval do
          register_attributes :id, :name, :description, readonly: [:id]

          def initialize(fields={})
            attributes[:id] = fields[:id]
            attributes[:name] = fields[:name]
            attributes[:description] = fields[:description]
          end
        end
      end

      it 'create getter method for all attributes' do
        expect(Trello::FakeBoard.new).to respond_to(:id, :name, :description)
      end

      it 'create setting method for all writable attributes' do
        expect(Trello::FakeBoard.new).to respond_to(:name=, :description=)
        expect(Trello::FakeBoard.new).not_to respond_to(:id=)
      end

      it 'any writable attributes changes will caused the record being marked as changed' do
        fake_board = Trello::FakeBoard.new(id: 1, name: 'test')
        expect(fake_board.changed?).to eq(false)
        fake_board.name = 'TEST'
        expect(fake_board.changed?).to eq(true)
      end
    end
  end

end
