require 'rails_helper'

RSpec.describe 'Records', type: :request do

  let(:user) { FactoryBot.create(:user, email: 'test@test.com', password: '12345678', password_confirmation: '12345678') }
  let(:punchcard) { FactoryBot.create(:punchcard, id: 1, user: user) }

  before :each do
    sign_in user
  end

  describe 'GET /punchcards/:id/records.json' do
    it 'returns punchcard records in JSON format' do
      FactoryBot.create(:record, hours: 10, description: '10 hour practice', punchcard: punchcard)
      FactoryBot.create(:record, hours: 5, description: '5 hour practice', punchcard: punchcard)
      FactoryBot.create(:record, hours: 5.5, description: '5 hour practice', punchcard: punchcard)

      get '/punchcards/1/records.json', headers: { 'Accept': 'application/vnd' }

      expect(response).to have_http_status 200

      record_hours = json_response.map { |record| record[1] }

      expect(record_hours).to eq([10, 5, 5.5])
    end
  end

  describe 'GET /punchcards/:id/records/search' do
    let(:record) { FactoryBot.create(:record, hours: 10, date: Time.zone.now,
      description: 'Blah', punchcard: punchcard) }

    it 'searches for record and returns its ID' do
      #pending 'Fix Nil return from controller'

      get '/punchcards/1/records/search',
        params: { record_date: record.date.strftime("%Y-%m-%d %H:%M:%S") },
        headers: { 'Accept': 'application/json' }

      expect(response).to have_http_status 200
      expect(json_response).to eq(record.id)
    end
  end

end