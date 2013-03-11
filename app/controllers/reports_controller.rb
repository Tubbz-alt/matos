class ReportsController < ApplicationController

  layout 'application'

  def new
    authorize! :create, Report
    @report = Report.new
  end

  def create
    authorize! :create, Report
    first_ext = params[:report].delete(:input_external_codes_one)
    second_ext = params[:report].delete(:input_external_codes_two)
    location = params[:report].delete(:location)
    location = location.empty? ? nil : location
    @report = Report.new(params[:report])
    @report.found = Date.strptime(params[:report][:found],"%m/%d/%Y").to_date rescue nil
    @report.input_external_codes = [first_ext,second_ext].compact.reject(&:empty?)
    @report.location = location.include?("POINT") ? location : "POINT(#{location.gsub(',','' '')})" rescue nil
    if params[:report][:input_tag]
      @report.tag_deployment = Tag.find_match(params[:report][:input_tag]).first.active_deployment rescue nil
    elsif !@report.input_external_codes.empty?
      @report.tag_deployment = TagDeployment.find_match(@report.input_external_codes)
    end
    if @report.save
      ReportMailer.report_invoice(@report).deliver
      if @report.tag_deployment
        ReportMailer.matched_report_notification(@report).deliver
      else
        ReportMailer.unmatched_report_notification(@report).deliver
      end
      respond_to do |format|
        flash["notice"] = "Submission complete. Thank you for your cooperation."
        format.html { redirect_to :action => :show, :id => @report.id }
      end
    else
      respond_to do |format|
        format.html { render :action => :new }
      end
    end
  end

  def show
    @report = Report.includes({:tag_deployment => [:tag, {:study => :user}]}).find(params[:id])
    respond_to do |format|
      format.html
    end
  end

end
