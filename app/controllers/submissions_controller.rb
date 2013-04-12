class SubmissionsController < ApplicationController

  def index
    @submissions = Submission.includes(:user).includes(:study).select { |s| can? :manage, s.study }
    respond_to do |format|
      format.html
    end
  end

  def new
    authorize! :create, Submission
    @submission = Submission.new
  end

  def create
    authorize! :create, Submission
    @submission = Submission.new( params[:submission] )
    authorize! :manage, @submission.study
    @submission.user = current_user
    @submission.status = "New"
    if @submission.save
      @submission.delay.process
      redirect_to submission_path(@submission), :notice => "Thank you, your submission was successfully submitted.  Information will be available shortly."
    else
      render :action => :new
    end
  end

  def show
    @submission = Submission.includes(:study).includes(:user).find(params[:id])
    authorize! :manage, @submission.study
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @submission = Submission.find(params[:id])
    authorize! :destroy, @submission
    @submission.destroy
    respond_to do |format|
      format.html
      format.js { render :json => nil, :status => :ok}
    end
  end

end
