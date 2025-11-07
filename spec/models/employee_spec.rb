require 'rails_helper'

RSpec.describe Employee, type: :model do
  subject { described_class.new(full_name: 'Alice', job_title: 'Engineer', country: 'India', salary: 1000.0) }


  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end


  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:job_title) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:salary) }


  it 'validates salary numericality' do
    subject.salary = -10
    expect(subject).to_not be_valid
  end
end
