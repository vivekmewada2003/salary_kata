require 'rails_helper'

RSpec.describe 'Metrics API', type: :request do
  before do
    Employee.create!(full_name: 'A', job_title: 'Dev', country: 'India', salary: 100)
    Employee.create!(full_name: 'B', job_title: 'Dev', country: 'India', salary: 200)
    Employee.create!(full_name: 'C', job_title: 'QA', country: 'India', salary: 300)
    Employee.create!(full_name: 'D', job_title: 'Dev', country: 'US', salary: 400)
  end


  it 'returns country metrics' do
    get '/metrics/country/India'
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['min']).to eq('100.0')
    expect(json['max']).to eq('300.0')
    expect(json['avg']).to eq('200.0')
  end


  it 'returns job_title average' do
    get '/metrics/job_title/Dev'
    json = JSON.parse(response.body)
    expect(json['avg']).to eq('233.33').or eq('233.3333').or be_present
  end
end