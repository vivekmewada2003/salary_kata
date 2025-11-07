class Employee < ApplicationRecord
    validates :full_name, :job_title, :country, presence: true
    validates :salary, presence: true, numericality: { greater_than_or_equal_to: 0 }
end