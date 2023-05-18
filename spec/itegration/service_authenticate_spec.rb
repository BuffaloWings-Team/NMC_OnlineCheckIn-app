# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { username: 'jacob.john', password: 'mypa$$w0rdispoop' }
    @mal_credentials = { username: 'jacob.john', password: 'wrongpassword' }
    @api_account = { attributes:
                       { username: 'jacob.john', email: 'jpoop@nthu.edu.tw' } }
  end

  after do
    WebMock.reset!
  end

  describe 'Find authenticated account' do
    it 'HAPPY: should find an authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @credentials.to_json)
             .to_return(body: @api_account.to_json,
                        headers: { 'content-type' => 'application/json' })

      account = OnlineCheckIn::AuthenticateAccount.new(app.config).call(**@credentials)
      _(account).wont_be_nil
      _(account['username']).must_equal @api_account[:attributes][:username]
      _(account['email']).must_equal @api_account[:attributes][:email]
    end

    it 'BAD: should not find a false authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @mal_credentials.to_json)
             .to_return(status: 403)
      _(proc {
        OnlineCheckIn::AuthenticateAccount.new(app.config).call(**@mal_credentials)
      }).must_raise OnlineCheckIn::AuthenticateAccount::UnauthorizedError
    end
  end
end
