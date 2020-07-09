require 'spec_helper'

RSpec.describe 'BasicData#schema' do

  around do |example|
    module Trello
      class FakeBoard < BasicData
        schema do
          attribute :id, readonly: true, primary_key: true
          attribute :name
          attribute :description, remote_key: :desc
          attribute :last_activity_date, readonly: true, remote_key: :dateLastActivity
          attribute :keep_cards_from_source, create_only: true, remote_key: :keepFromSource
          attribute :subscribed, update_only: true, default: true
        end
      end
    end

    example.run

    Trello.send(:remove_const, 'FakeBoard')
  end

  let(:attributes) { FakeBoard.schema.attrs }
  let(:stringify_init_params) {{
    'id' => 99,
    'name' => 'Test Board',
    'desc' => 'board desc ...',
    'dateLastActivity' => '2020-02-20 00:00:00',
    'keepFromSource' => true,
    'subscribed' => true
  }}

  let(:symbolize_init_params) {{
    id: 99,
    name: 'Test Board',
    description: 'board desc ...',
    last_activity_date: Time.new(2020, 2, 20),
    keep_cards_from_source: true,
    subscribed: true
  }}

  it 'will create 6 attributes' do
    expect(attributes.count).to eq(6)
  end

  it 'can success parse readonly primary key :id' do
    attribute = attributes[:id]
    expect(attribute.name).to eq(:id)
    expect(attribute.primary_key?).to eq(true)
    expect(attribute.readonly?).to eq(true)
    expect(attribute.remote_key).to eq('id')
    expect(attribute.for_action?(:create)).to eq(false)
    expect(attribute.for_action?(:update)).to eq(true)
    expect(attribute.default).to eq(nil)
    expect(attribute.build_attributes({id: 1, name: 'Test'}, {})).to eq({id: 1})
    expect(attribute.build_attributes({'id' => 1, 'name' => 'Text'}, {})).to eq({id: 1})
    expect(attribute.build_payload_for_create({ id: 1, name: 'Text' }, {})).to eq({})
    expect(attribute.build_payload_for_update({ id: 1, name: 'Text' }, {})).to eq({ 'id' => 1 })
  end

  it 'can succes parse attribute :name with default setting' do
    attribute = attributes[:name]
    expect(attribute.name).to eq(:name)
    expect(attribute.primary_key?).to eq(false)
    expect(attribute.readonly?).to eq(false)
    expect(attribute.remote_key).to eq('name')
    expect(attribute.for_action?(:create)).to eq(true)
    expect(attribute.for_action?(:update)).to eq(true)
    expect(attribute.default).to eq(nil)
    expect(attribute.build_attributes({id: 1, name: 'Test'}, {})).to eq({name: 'Test'})
    expect(attribute.build_attributes({'id' => 1, 'name' => 'Text'}, {})).to eq({name: 'Text'})
    expect(attribute.build_payload_for_create({ id: 1, name: 'Text' }, {})).to eq({ 'name' => 'Text' })
    expect(attribute.build_payload_for_update({ id: 1, name: 'Text' }, {})).to eq({ 'name' => 'Text' })
  end

  it 'can succes parse attribute :description with diferent remote_key' do
    attribute = attributes[:description]
    expect(attribute.name).to eq(:description)
    expect(attribute.primary_key?).to eq(false)
    expect(attribute.readonly?).to eq(false)
    expect(attribute.remote_key).to eq('desc')
    expect(attribute.for_action?(:create)).to eq(true)
    expect(attribute.for_action?(:update)).to eq(true)
    expect(attribute.default).to eq(nil)
    expect(attribute.build_attributes({id: 1, description: '...'}, {})).to eq({description: '...'})
    expect(attribute.build_attributes({'id' => 1, 'desc' => '...'}, {})).to eq({description: '...'})
    expect(attribute.build_payload_for_create({ id: 1, description: '...' }, {})).to eq({ 'desc' => '...' })
    expect(attribute.build_payload_for_update({ id: 1, description: '...' }, {})).to eq({ 'desc' => '...' })
  end

  it 'can success parse attribute :keep_cards_from_source with create_only and remote_key' do
    attribute = attributes[:keep_cards_from_source]
    expect(attribute.name).to eq(:keep_cards_from_source)
    expect(attribute.primary_key?).to eq(false)
    expect(attribute.readonly?).to eq(false)
    expect(attribute.remote_key).to eq('keepFromSource')
    expect(attribute.for_action?(:create)).to eq(true)
    expect(attribute.for_action?(:update)).to eq(false)
    expect(attribute.default).to eq(nil)
    expect(attribute.build_attributes({id: 1, keep_cards_from_source: true}, {})).to eq({keep_cards_from_source: true})
    expect(attribute.build_attributes({'id' => 1, 'keepFromSource' => true}, {})).to eq({keep_cards_from_source: true})
    expect(attribute.build_payload_for_create({ id: 1, keep_cards_from_source: true }, {})).to eq({ 'keepFromSource' => true })
    expect(attribute.build_payload_for_update({ id: 1, keep_cards_from_source: true }, {})).to eq({})
  end

  it 'can succes parse attribute :subscribed with update only' do
    attribute = attributes[:subscribed]
    expect(attribute.name).to eq(:subscribed)
    expect(attribute.primary_key?).to eq(false)
    expect(attribute.readonly?).to eq(false)
    expect(attribute.remote_key).to eq('subscribed')
    expect(attribute.for_action?(:create)).to eq(false)
    expect(attribute.for_action?(:update)).to eq(true)
    expect(attribute.default).to eq(true)
    expect(attribute.build_attributes({id: 1, subscribed: true}, {})).to eq({subscribed: true})
    expect(attribute.build_attributes({id: 1}, {})).to eq({subscribed: true})
    expect(attribute.build_attributes({'id' => 1, 'subscribed' => true}, {})).to eq({subscribed: true})
    expect(attribute.build_payload_for_create({ id: 1, subscribed: true }, {})).to eq({})
    expect(attribute.build_payload_for_update({ id: 1, subscribed: true }, {})).to eq({ 'subscribed' => true })
  end

end
