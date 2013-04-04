class SearchController < ApplicationController

  layout 'search'

  def index

  end

  def tag
    authorize! :manage, Tag
  end

  def match_tags
    z_tags = params[:text].split(",").map(&:strip)

    tags_match = Tag.exact_match(z_tags.join(" ")).map(&:id)
    deps_match = TagDeployment.includes(:tag).exact_match(z_tags).map{ |td| td.tag.id }
    ids_match = z_tags.map{ |z| Tag.find_all_matches(z).map(&:id) }

    ids = (tags_match + deps_match + ids_match).uniq

    tags = Tag.includes({:active_deployment => {:study => :user}}).where(:id => ids)

    # TODO: Do we need only return tags the user can manage?
    # tags.select! { |t| can? :manage, t }
    render :json => tags.as_json({
                      :only => [:id, :code, :code_space, :model],
                      :methods => [:active_deployment_json]
                      })
  end

  def tags
    tags = Tag.includes({:tag_deployments => :study}).search_all(params[:text])
    deps = TagDeployment.includes(:tag).includes(:study).search_all(params[:text]).map(&:tag)
    tags = (tags + deps).select { |t| can? :manage, t }
    render :json => tags.as_json({
                      :only => [:id, :code, :code_space],
                      :methods => [:active_deployment_json]
                    })
  end

  def reports
    reports = Report.inclues(:tag).includes({:tag_deployment => :study}).search_all(params[:text])
    render :json => reports.as_json({
                      :include => [
                        {:tag => {
                          :only => [:id,:code]
                        }},

                        {:tag_deployment => {
                          :only => [nil],
                          :include => 
                            {:study => {
                              :only => [:id, :name]
                            }}
                        }}
                      ]
                    })
  end

  def studies
    studies = Study.search_all(params[:text])
    render :json => studies.as_json({

    })
  end

  def receivers
    recs = ReceiverDeployment.includes(:receiver).includes(:study).search_all(params[:text])
    render :json => recs.as_json({
                      :only => [:id, :start, :ending, :seasonal],
                      :methods => [:code],
                      :include => {
                        :study => { :only => [:id, :name] },
                        :otn_array => { :only => :name },
                        :receiver => { :only => [:model, :serial] }
                      }
                    })
  end

end
