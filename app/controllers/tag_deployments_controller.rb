class TagDeploymentsController < ApplicationController

    def show
        @tag_deployment = TagDeployment.includes(:tag).includes( { :hits => { :receiver_deployment => [:receiver, :otn_array] }} ).includes(:report).find(params[:id])
        authorize! :read, @tag_deployment
        respond_to do |format|
            format.html
            format.geo { render :json => @tag_deployment.geojson }
        end
    end

end