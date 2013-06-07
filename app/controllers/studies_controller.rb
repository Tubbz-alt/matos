class StudiesController < ApplicationController

  def index
    @studies = Study.active.order(:id)
    @studies = @studies.select{ |s| can? :read, s }
    respond_to do |format|
      format.json {
        render :json => @studies.as_json
      }
    end
  end

  def new
    authorize! :create, Study
    @study = Study.new
  end

  def create
    authorize! :create, Study
    @study = Study.new( params[:study] )
    @study.user = current_user
    @study.approved = false
    if @study.save
      redirect_to study_path(@study), :notice => "You will be contacted via email when your study has been approved"
    else
      render :action => :new
    end
  end

  def show
    @study = Study.includes(:user, {:receiver_deployments => :receiver}, {:tag_deployments => :tag}).find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def edit
    @study = Study.includes(:user).find(params[:id])
    authorize! :update, @study
    respond_to do |format|
      format.html
    end
  end

  def update
    @study = Study.includes(:user).find(params[:id])
    authorize! :update, @study
    if @study.update_attributes(params[:study])
      flash[:notice] = 'Project was successfully updated.'
      redirect_to project_path(@study)
    else
      render :action => 'edit'
    end
  end

end
