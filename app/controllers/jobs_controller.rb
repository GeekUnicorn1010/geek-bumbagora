class JobsController < ApplicationController
  before_action :set_job, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy]
  

  include JobsConcern
  include JobsViewsConcern

  def search 
    @jobs = Job.find_jobs_by_title_or_category_name(params[:job])
    @page_name_index = page_name("index")
  end
  
  def index
    @jobs = Job.find_jobs_ordered_by_id_desc
    @page_name_index = page_name("index")
  end

  # GET /jobs/1 or /jobs/1.json
  def show
    @page_name_index = page_name("show")
  end

  # GET /jobs/new
  def new
    if user_signed_in?
       @job = Job.new
       @categories = Category.all
    else
      redirect_to new_user_session_path
    end
  end

  # GET /jobs/1/edit
  def edit
  end

  # POST /jobs or /jobs.json
  def create
    @job = Job.new(job_params)
    @job.user_id = current_user.id
    respond_to do |format|
      if @job.save
        format.html { redirect_to job_url(@job), notice: "Job was successfully created." }
        format.json { render :show, status: :created, location: @job }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs/1 or /jobs/1.json
  def update
    respond_to do |format|
      if @job.update(job_params)
        format.html { redirect_to job_url(@job), notice: "Job was successfully updated." }
        format.json { render :show, status: :ok, location: @job }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1 or /jobs/1.json
  def destroy
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url, notice: "Job was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def job_params
      params.require(:job).permit(:title, :type_job, :description, :salary, :expiry_date, :category_id, )
    end

end
