class JobsController < ApplicationController
  def index
    if params[:sort] == 'location'
      @jobs = Job.by_city
      render :city_sorted
    elsif params[:sort] == 'interest'
      @jobs = Job.by_interest
      render :interest_sorted
    elsif params[:location]
      @city = params[:location]
      @jobs = Job.all.where(:city => params[:location])
      render :city_jobs
    elsif params[:company_id]
      @company = Company.find(params[:company_id])
      @jobs = @company.jobs
      @contact = Contact.new(company_id: @company.id)
    else
      @jobs = Job.all
      render :all
    end
  end

  def new
    @company = Company.find(params[:company_id])
    @job = Job.new()
  end

  def create
    @company = Company.find(params[:company_id])
    @job = @company.jobs.new(job_params)
    if @job.save
      flash[:success] = "You created #{@job.title} at #{@company.name}"
      redirect_to job_path(@job)
    else
      render :new
    end
  end

  def show
    @job = Job.find(params[:id])
    @comment = Comment.new(job_id: @job.id)
    @company = @job.company
  end

  def edit
    @job = Job.find(params[:id])
    @company = Company.find(params[:company_id])
  end

  def update
    @job = Job.find(params[:id])
    @job.update(job_params)
    if @job.save
      flash[:success] = "#{@job.title} updated!"
      redirect_to company_job_path(@job.company, @job)
    else
      render :edit
    end
  end

  def destroy
    Company.find(params[:company_id])
    job = Job.find(params[:id])
    job.destroy

    flash[:success] = "#{job.title} was successfully deleted!"

    redirect_to company_jobs_path
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :level_of_interest, :city, :category_id)
  end
end
