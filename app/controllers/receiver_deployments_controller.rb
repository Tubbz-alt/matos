class ReceiverDeploymentsController < ApplicationController

  def index
    @receivers = ReceiverDeployment.includes([:otn_array, :study, :receiver]).order('study_id ASC').select { |d| can? :read, d }
    respond_to do |format|
      format.geo {
        render :json =>
          @receivers.as_json({
            :only => [nil],
            :methods => [:geojson]
          })
      }
    end
  end

end
