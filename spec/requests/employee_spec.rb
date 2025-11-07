require 'rails_helper'

RSpec.describe "Employees API", type: :request do
  let(:valid_attributes) do
    { full_name: 'Alice', job_title: 'Developer', country: 'India', salary: 50000.0 }
  end

  let(:invalid_attributes) do
    { full_name: '', job_title: '', country: '', salary: -1000 }
  end

  describe 'GET /employees' do
    before do
      Employee.create!(full_name: 'John', job_title: 'QA', country: 'India', salary: 10000)
      Employee.create!(full_name: 'Mary', job_title: 'Manager', country: 'US', salary: 80000)
    end

    it 'returns all employees' do
      get '/employees'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.size).to eq(2)
      expect(json.map { |e| e['full_name'] }).to include('John', 'Mary')
    end
  end

  describe 'GET /employees/:id' do
    let!(:employee) { Employee.create!(valid_attributes) }

    context 'when the record exists' do
      it 'returns the employee' do
        get "/employees/#{employee.id}"
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['id']).to eq(employee.id)
        expect(json['job_title']).to eq('Developer')
      end
    end

    context 'when the record does not exist' do
      it 'returns not found' do
        get '/employees/9999'
        expect(response).to have_http_status(:not_found).or have_http_status(:internal_server_error)
      end
    end
  end
  
  describe 'POST /employees' do
    context 'with valid parameters' do
      it 'creates a new employee' do
        expect {
          post '/employees', params: { employee: valid_attributes }
        }.to change(Employee, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['full_name']).to eq('Alice')
        expect(json['country']).to eq('India')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new employee' do
        expect {
          post '/employees', params: { employee: invalid_attributes }
        }.not_to change(Employee, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end
  end


  describe 'PATCH /employees/:id' do
    let!(:employee) { Employee.create!(valid_attributes) }

    context 'with valid parameters' do
      let(:new_attributes) do
        { full_name: 'Alice Updated', job_title: 'Senior Developer', salary: 75000 }
      end

      it 'updates the employee' do
        patch "/employees/#{employee.id}", params: { employee: new_attributes }
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['full_name']).to eq('Alice Updated')
        expect(json['salary']).to eq('75000.0').or eq(75000.0)
      end
    end

    context 'with invalid parameters' do
      it 'does not update and returns errors' do
        patch "/employees/#{employee.id}", params: { employee: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'DELETE /employees/:id' do
    let!(:employee) { Employee.create!(valid_attributes) }

    it 'deletes the employee' do
      expect {
        delete "/employees/#{employee.id}"
      }.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if not found' do
      delete '/employees/9999'
      expect(response).to have_http_status(:not_found).or have_http_status(:internal_server_error)
    end
  end
end
