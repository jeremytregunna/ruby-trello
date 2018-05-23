require 'rubygems'

unless defined? Rubinius
  require 'simplecov'
  SimpleCov.start
end

begin
  require 'pry-byebug'
rescue LoadError
end

# Set up gems listed in the Gemfile.
begin
  ENV['BUNDLE_GEMFILE'] = File.expand_path('../Gemfile', File.dirname(__FILE__))
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts 'Try running `bundle install`.'
  exit!
end

Bundler.require(:spec)

require 'trello'
require 'webmock/rspec'
require 'stringio'

Trello.logger = Logger.new(StringIO.new)

RSpec.configure do |rspec|
  rspec.filter_run_excluding broken: true

  rspec.before :each do
    Trello.reset!
  end

  rspec.around(:each, :silence_warnings) do |example|
    verbose = $VERBOSE
    $VERBOSE = nil
    example.run
    $VERBOSE = verbose
  end
end

module Helpers
  def user_details
    {
      'id'         => 'abcdef123456789012345678',
      'fullName'   => 'Test User',
      'username'   => 'me',
      'intials'    => 'TU',
      'avatarHash' => 'abcdef1234567890abcdef1234567890',
      'bio'        => 'a rather dumb user',
      'url'        => 'https://trello.com/me',
      'email'      => 'johnsmith@example.com'
    }
  end

  def user_payload
    JSON.generate(user_details)
  end

  def boards_details
    [{
      'id'               => 'abcdef123456789123456789',
      'name'             => 'Test',
      'desc'             => 'This is a test board',
      'closed'           => false,
      'starred'          => false,
      'idOrganization'   => 'abcdef123456789123456789',
      'url'              => 'https://trello.com/board/test/abcdef123456789123456789',
      'dateLastActivity' => '2012-12-08T18:40:24.314Z'
    },
    {
      name:            'Test',
      desc:            'This is a test board',
      closed:          false,
      starred:         false,
      organization_id: 'abcdef123456789123456789'
    }]
  end

  def boards_payload
    JSON.generate(boards_details)
  end

  def checklists_details
    [{
      'id'         => 'abcdef123456789123456789',
      'name'       => 'Test Checklist',
      'desc'       => 'A marvelous little checklist',
      'closed'     => false,
      'pos'        => 16384,
      'url'        => 'https://trello.com/blah/blah',
      'idBoard'    => 'abcdef123456789123456789',
      'idCard'     => 'abccardid',
      'idList'     => 'abcdef123456789123456789',
      'idMembers'  => ['abcdef123456789123456789'],
      'checkItems' => { 'id' => 'ghijk987654321' }
    },
    {
      name:    'A marvelous little checklist',
      card_id: 'abccardid'
    }]
  end

  def checklists_payload
    JSON.generate(checklists_details)
  end

  def copied_checklists_details
    [{
      'id'         => 'uvwxyz987654321987654321',
      'name'       => 'Test Checklist',
      'desc'       => '',
      'closed'     => nil,
      'position'   => 99999,
      'url'        => nil,
      'idBoard'    => 'abcdef123456789123456789',
      'idList'     => nil,
      'idMembers'  => nil,
      'checkItems' => []
    }]
  end

  def copied_checklists_payload
    JSON.generate(copied_checklists_details)
  end

  def lists_details
    [{
      'id'           => 'abcdef123456789123456789',
      'name'         => 'To Do',
      'closed'       => false,
      'idBoard'      => 'abcdef123456789123456789',
      'idListSource' => 'abcdef123456789123456780',
      'cards'        => cards_details,
      'pos'          => 12
    },
    {
      name:           'To Do',
      board_id:       'abcdef123456789123456789',
      pos:            12,
      source_list_id: 'abcdef123456789123456780'
    }
    ]
  end

  def lists_payload
    JSON.generate(lists_details)
  end

  def cards_details
    [{
      'id'                => 'abcdef123456789123456789',
      'idShort'           => '1',
      'name'              => 'Do something awesome',
      'desc'              => 'Awesome things are awesome.',
      'closed'            => false,
      'idList'            => 'abcdef123456789123456789',
      'idBoard'           => 'abcdef123456789123456789',
      'idAttachmentCover' => 'abcdef123456789123456789',
      'idMembers'         => ['abcdef123456789123456789'],
      'labels'            => label_details,
      'idLabels'          => [ 'abcdef123456789123456789',
                               'bbcdef123456789123456789',
                               'cbcdef123456789123456789',
                               'dbcdef123456789123456789' ],
      'url'               => 'https://trello.com/card/board/specify-the-type-and-scope-of-the-jit-in-a-lightweight-spec/abcdef123456789123456789/abcdef123456789123456789',
      'shortUrl'          => 'https://trello.com/c/abcdef12',
      'pos'               => 12,
      'dateLastActivity'  => '2012-12-07T18:40:24.314Z'
    },
    {
      name:                   'Do something awesome',
      list_id:                'abcdef123456789123456789',
      desc:                   'Awesome things are awesome.',
      member_ids:             ['abcdef123456789123456789'],
      card_labels:            [ 'abcdef123456789123456789',
                              'bbcdef123456789123456789',
                              'cbcdef123456789123456789',
                              'dbcdef123456789123456789' ],
      due:                    Date.today,
      pos:                    12,
      source_card_id:         'abcdef1234567891234567890',
      source_card_properties: 'checklist,members'
    }]
  end


  def cards_payload
    JSON.generate(cards_details)
  end

  def attachments_details
    [{
       'id'           => 'abcdef123456789123456789',
       'name'         => 'attachment1.png',
       'url'          => 'http://trello-assets.domain.tld/attachment1.png',
       'bytes'        => 98765,
       'idMember'     => 'abcdef123456789123456781',
       'isUpload'     => false,
       'date'         => '2013-02-28T17:12:28.497Z',
       'previews'     => 'previews'
     },
     {
       'id'           => 'abcdef123456789123456781',
       'name'         => 'attachment2.png',
       'url'          => 'http://trello-assets.domain.tld/attachment2.png',
       'bytes'        => 89123,
       'idMember'     => 'abcdef123456789123456782',
       'isUpload'     => true,
       'date'         => '2013-03-01T14:01:25.212Z',
     }]
  end

  def attachments_payload
    JSON.generate(attachments_details)
  end

  def plugin_data_details
    [
      {
        "id"=>"abcdef123456789123456779",
        "idPlugin"=>"abcdef123456789123456879",
        "scope"=>"card",
        "idModel"=>"abcdef123456789123446879",
        "value"=>"{\"fields\":{\"plugin_key\":\"plugin_value\"}}",
        "access"=>"shared"
      },
      {
        "id"=>"abcdef123456789123456879",
        "idPlugin"=>"abcdef123456789123456779",
        "scope"=>"card",
        "idModel"=>"abcdef123456789123446579",
        "value"=>"{\"fields\":{\"plugin_key\":\"plugin_value\"}}",
        "access"=>"shared"
      }
    ]
  end

  def plugin_data_payload
    JSON.generate(plugin_data_details)
  end

  def card_payload
    JSON.generate(cards_details.first)
  end

  def orgs_details
    [{
      'id'          => 'abcdef123456789123456789',
      'name'        => 'test',
      'displayName' => 'Test Organization',
      'desc'        => 'This is a test organization',
      'url'         => 'https://trello.com/test'
    }]
  end

  def orgs_payload
    JSON.generate(orgs_details)
  end

  def actions_details
    [{
      'id'              => '4ee2482134a81a757a08af47',
      'idMemberCreator' => 'abcdef123456789123456789',
      'data' => {
        'card'          => {
          'id'          => '4ee2482134a81a757a08af45',
          'name'        => 'Bytecode outputter'
        },
        'board'         => {
          'id'          => '4ec54f2f73820a0dea0d1f0e',
          'name'        => 'Caribou VM'
        },
        'list'          => {
          'id'          => '4ee238b034a81a757a05cda0',
          'name'        => 'Assembler'
        }
      },
      'date'            => '2012-02-10T11:32:17Z',
      'type'            => 'createCard'
    }]
  end

  def actions_payload
    JSON.generate(actions_details)
  end

  def notification_details
    {
      'id'              => '4f30d084d5b0f7ab453bee51',
      'unread'          => false,
      'type'            => 'commentCard',
      'date'            => '2012-02-07T07:19:32.393Z',
      'data'            => {
        'board'         => {
          'id'          => 'abcdef123456789123456789',
          'name'        => 'Test'
        },
        'card' =>{
          'id'          => 'abcdef123456789123456789',
          'name'        => 'Do something awesome'
        },
        'text'          => 'test'
      },
      'idMemberCreator' => 'abcdef123456789012345678'
    }
  end

  def notification_payload
    JSON.generate(notification_details)
  end

  def organization_details
    {
        'id' => '4ee7e59ae582acdec8000291',
        'name' => 'publicorg',
        'desc' => 'This is a test organization',
        'members' => [{
            'id' => '4ee7df3ce582acdec80000b2',
            'username' => 'alicetester',
            'fullName' => 'Alice Tester'
        }, {
            'id' => '4ee7df74e582acdec80000b6',
            'username' => 'davidtester',
            'fullName' => 'David Tester'
        }, {
            'id' => '4ee7e2e1e582acdec8000112',
            'username' => 'edtester',
            'fullName' => 'Ed Tester'
        }]
    }
  end

  def organization_payload
    JSON.generate(organization_details)
  end

  def token_details
    {
      'id'            => '4f2c10c7b3eb95a45b294cd5',
      'idMember'      => 'abcdef123456789123456789',
      'dateCreated'   => '2012-02-03T16:52:23.661Z',
      'permissions'   => [
        {
          'idModel'   => 'me',
          'modelType' => 'Member',
          'read'      => true,
          'write'     => true
        },
        {
          'idModel'   => '*',
          'modelType' => 'Board',
          'read'      => true,
          'write'     => true
        },
        {
          'idModel'   => '*',
          'modelType' => 'Organization',
          'read'      => true,
          'write'     => true
        }
      ]
    }
  end

  def token_payload
    JSON.generate(token_details)
  end

  def label_details
    [
      {'color' => 'yellow', 'name' => 'iOS', 'id' => 'abcdef123456789123456789', 'uses' => 3, 'idBoard' => 'abcdef123456789123456789'},
      {'color' => 'purple', 'name' => 'Issue or bug', 'id' => 'bbcdef123456789123456789', 'uses' => 1, 'idBoard' => 'abcdef123456789123456789'},
      {'color' => 'red', 'name' => 'deploy', 'id' => 'cbcdef123456789123456789', 'uses' => 2, 'idBoard' => 'abcdef123456789123456789'},
      {'color' => 'blue', 'name' => 'on hold', 'id' => 'dbcdef123456789123456789', 'uses' => 6, 'idBoard' => 'abcdef123456789123456789'}
    ]
  end

  def label_options
    {
      name:     'iOS',
      board_id: 'abcdef123456789123456789',
      color:    'yellow'
    }
  end

  def label_payload
    JSON.generate(label_details)
  end

  def webhooks_details
    [
     {
       'id'          => 'webhookid',
       'description' => 'Test webhook',
       'idModel'     => '1234',
       'callbackURL' => 'http://example.org/webhook',
       'active'      => true
     },
     {
       description:  'Test webhook',
       id_model:     '1234',
       cakkback_url: 'http://example.org/webhook'
     }
    ]
  end

  def label_name_details
  [
    {'yellow' => 'bug'},
    {'red' => 'urgent'},
    {'green' => 'deploy'},
    {'blue' => 'on hold'},
    {'orange' => 'new feature'},
    {'purple' => 'experimental'}
  ]
  end

  def label_name_payload
    JSON.generate(label_name_details)
  end

  def custom_fields_details
    [
      {
        'id' => 'abcdef123456789123456789',
        'name' => 'Priority',
        'idModel' => 'abc123',
        'type' => 'checkbox',
        'pos' => 123,
        'modelType' => 'board'
      },
      {
        id: 'abcdef123456789123456789',
        name: 'Priority',
        model_id: 'abc123',
        type: 'checkbox',
        pos: 123,
        model_type: 'board'
      }
    ]
  end

  def custom_fields_payload
    JSON.generate(custom_fields_details.first)
  end

  def custom_field_option_details
    {
      '_id'   => 'abcdefgh12345678',
      'value' => {'text' => 'Low Priority'},
      'color' => 'green',
      'pos' => 1
    }
  end

  def custom_field_item_details
    {
      'id' => 'abcdefg1234567',
      'value' => { 'text' => 'hello world' },
      'idModel' => 'abcdef123456789123456789',
      'idCustomField' => 'abcdef123456789123456789',
      'modelType' => 'card'
    }
  end

  def custom_field_items_payload
    JSON.generate(custom_field_item_details)
  end

  def webhooks_payload
    JSON.generate(webhooks_details)
  end

  def webhook_payload
    JSON.generate(webhooks_details.first)
  end
end
