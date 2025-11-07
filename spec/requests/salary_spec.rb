require 'rails_helper'

RSpec.describe 'Salary Calculation API', type: :request do
  let!(:emp_in) { Employee.create!(full_name: 'A', job_title: 'Dev', country: 'India', salary: 1000) }
  let!(:emp_us) { Employee.create!(full_name: 'B', job_title: 'Dev', country: 'United States', salary: 2000) }
  let!(:emp_other) { Employee.create!(full_name: 'C', job_title: 'Dev', country: 'Germany', salary: 1500) }

  it 'calculates salary for India' do
    get "/employees/#{emp_in.id}/salary"
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['gross']).to eq('1000.0')
    expect(json['tds']).to eq('100.0')
    expect(json['net']).to eq('900.0')
  end

  it 'calculates salary for US' do
    get "/employees/#{emp_us.id}/salary"
    json = JSON.parse(response.body)
    expect(json['tds']).to eq('240.0')
    expect(json['net']).to eq('1760.0')
  end

  it 'calculates salary for other countries (no deductions)' do
    get "/employees/#{emp_other.id}/salary"
    json = JSON.parse(response.body)
    expect(json['tds']).to eq('0.0')
    expect(json['net']).to eq('1500.0')
  end
end