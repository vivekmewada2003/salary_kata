class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy, :salary]

  # Rescue for not found records
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    employees = Employee.all
    render json: employees, status: :ok
  end

  def show
    render json: @employee, status: :ok
  end

  def create
    employee = Employee.new(employee_params)
    if employee.save
      render json: employee, status: :created
    else
      render json: { errors: employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @employee.update(employee_params)
      render json: @employee, status: :ok
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    head :no_content
  end

  def salary
    employee = @employee
    gross = employee.salary.to_f
    tds = case employee.country.strip.downcase
          when 'india', 'in', 'bharat' then gross * 0.10
          when 'united states', 'us', 'usa' then gross * 0.12
          else 0.0
          end
    net = gross - tds

    render json: { gross: gross.to_s, tds: tds.to_s, net: net.to_s }, status: :ok
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:full_name, :job_title, :country, :salary)
  end

  def record_not_found
    render json: { errors: ['Employee not found'] }, status: :not_found
  end
end
