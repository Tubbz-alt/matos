class DeploymentsController < ApplicationController

  def index
    @deployments = Deployment.includes([:otn_array, :retrieval]).order('study_id ASC').select { |d| can? :read, d }
    respond_to do |format|
      format.geo {
        render :json =>
          @deployments.as_json({
            :only => [nil],
            :methods => [:geojson]
          })
      }
    end
  end

end
