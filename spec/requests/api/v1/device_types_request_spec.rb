# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::DeviceTypes, type: :request do
  include Rack::Test::Methods

  content_type_json = { 'CONTENT_TYPE' => 'application/json' }

  let(:api_token) do
    User.create!(email: 'admin@netam.local', password: 'azertyuiop123', admin: true)

    post oauth_token_path, { 'grant_type' => 'password',
                             'username' => 'admin@netam.local',
                             'password' => 'azertyuiop123' }, headers: content_type_json

    oauth_response = JSON.parse(last_response.body)

    "#{oauth_response['token_type']} #{oauth_response['access_token']}"
  end

  context 'with GET /api/v1/device_types' do
    it 'returns an empty array' do
      header 'Authorization', api_token
      get '/api/v1/device_types'

      expect(last_response.header['Content-Type']).to include 'application/json'
      expect(last_response.status).to eq(200)
      expect(last_response.body).not_to be_nil
    end
  end

  context 'with POST /api/v1/device_types' do
    it 'create and return device type' do
      header 'Authorization', api_token
      post('/api/v1/device_types', { name: 'test type', color: '#ff00ff' }.to_json, content_type_json)

      expect(last_response.header['Content-Type']).to include 'application/json'
      expect(last_response.status).to eq(201)
      expect(last_response.body).not_to be_nil
    end
  end

  context 'with GET /api/v1/device_types/:id' do
    let(:device_type) { create(:device_type) }

    it 'returns a device type' do
      header 'Authorization', api_token
      get "/api/v1/device_types/#{device_type.id}"

      expect(last_response.header['Content-Type']).to include 'application/json'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq({ id: device_type.id, name: device_type.name, color: device_type.color }.to_json)
    end
  end
end
