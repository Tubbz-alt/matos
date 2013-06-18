class TagDeploymentsController < ApplicationController

    def show
        @tag_deployment = TagDeployment.includes(:tag).includes( { :hits => { :receiver_deployment => [:receiver, :otn_array] }} ).includes(:report).readable(current_user).where("tag_deployments.id = #{params[:id]}").first
        if @tag_deployment.nil?
            flash[:error] = "Permission Denied"
            redirect_to root_path
        else
            respond_to do |format|
                format.html
                format.geo { render :json => @tag_deployment.geojson }
            end
        end
    end

end