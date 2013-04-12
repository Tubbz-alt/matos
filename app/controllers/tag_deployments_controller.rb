class TagDeploymentsController < ApplicationController

    def show
        @tag_deployment = TagDeployment.includes(:tag).includes(:hits).includes(:report).find(params[:id])
        authorize! :read, @tag_deployment
    end

end