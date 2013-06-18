class TagsController < ApplicationController
    def show
        @tag = Tag.includes(:tag_deployments => :study).find(params[:id])
        @unmatched_hits = @tag.unmatched_hits
        @tag_deployments = TagDeployment.readable(current_user).where("tag_id = #{@tag.id}")
        respond_to do |format|
          format.html
        end
    end
end