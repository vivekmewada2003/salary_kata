class MetricsController < ApplicationController
  def country
    country = params[:country].to_s.strip.downcase
    employees = Employee.where('lower(country) = ?', country)

    if employees.exists?
      min_salary = employees.minimum(:salary).to_f
      max_salary = employees.maximum(:salary).to_f
      avg_salary = employees.average(:salary).to_f.round(2)

      render json: {
        country: params[:country],
        min: min_salary.to_s,
        max: max_salary.to_s,
        avg: avg_salary.to_s
      }, status: :ok
    else
      render json: { message: 'No employees found for this country' }, status: :not_found
    end
  end

  def job_title
    job_title = params[:job_title].to_s.strip.downcase
    employees = Employee.where('lower(job_title) = ?', job_title)

    if employees.exists?
      avg_salary = employees.average(:salary).to_f.round(2)
      render json: {
        job_title: params[:job_title],
        avg: avg_salary.to_s
      }, status: :ok
    else
      render json: { message: 'No employees found for this job title' }, status: :not_found
    end
  end
end
