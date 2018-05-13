require 'rails_helper'

describe 'user deletes an existing job' do
  scenario 'a user can delete a job' do
    company = Company.create!(name: "ESPN")
    job = company.jobs.create!(title: "Developer", level_of_interest: 70, city: "Denver")
    visit company_jobs_path(company, job)

    click_link "Delete"

    expect(page).to have_content("Developer was successfully deleted!")
  end
end
