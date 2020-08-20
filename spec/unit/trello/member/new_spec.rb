
require 'spec_helper'

RSpec.describe 'Trello::Member#new' do

  let(:member) { Trello::Member.new(data) }

  describe 'parse #id (readonly primary_key)' do
    context 'with Trello API respone data' do
      let(:data) { { 'id' => '5e93ba98614ac22d22f085c4' } }

      it "parse from data['id']" do
        expect(member.id).to eq('5e93ba98614ac22d22f085c4')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { id: '5e93ba98614ac22d22f085c4' } }

      it 'parse from data[:id]' do
        expect(member.id).to eq('5e93ba98614ac22d22f085c4')
      end
    end
  end

  describe 'parse #username (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'username' => 'hoppertest' } }

      it "parse from data['username']" do
        expect(member.username).to eq('hoppertest')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { username: 'hoppertest' } }

      it 'parse from data[:id]' do
        expect(member.username).to eq('hoppertest')
      end
    end
  end

  describe 'parse #full_name (writable)' do
    context 'with Trello API respone data' do
      let(:data) { { 'fullName' => 'hoppertest' } }

      it "parse from data['fullName']" do
        expect(member.full_name).to eq('hoppertest')
      end
    end

    context 'with Ruby-like data' do
      let(:data) { { full_name: 'hoppertest' } }

      it 'parse from data[:full_name]' do
        expect(member.full_name).to eq('hoppertest')
      end
    end
  end

end
