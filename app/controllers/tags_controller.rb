class TagsController < ApplicationController
    def show
        @tag = Tag.includes(:tag_deployments => :study).find(params[:id])
        @unmatched_hits = @tag.unmatched_hits
        @tag_deployments = @tag.tag_deployments.select{ |td| can? :read, td }
        respond_to do |format|
          format.html
        end
    end
end