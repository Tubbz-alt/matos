class ReceiverDeploymentsController < ApplicationController

  def index
    @receivers = ReceiverDeployment.includes([:otn_array, :study, :receiver]).readable(current_user).order('studies.name ASC')
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
