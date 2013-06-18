class SearchController < ApplicationController

  def index
  end

  def tag
  end


  def studies
    studies = Study.includes(:user).includes(:users).search_all(params[:text])

    render :json => studies.as_json({
                      :only => [:id, :name, :title, :species, :start, :ending, :seasonal]
                    })
  end

  def receivers
    privs = ReceiverDeployment.readable(current_user)
    searches = ReceiverDeployment.includes(:otn_array).includes(:receiver).search_all(params[:text])
    recs = privs & searches

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


  def tags
    z_tags = params[:text].split(",").map(&:strip)
    ids_match = z_tags.map{ |z| Tag.find_all_matches(z).map(&:id) }

    tags_match = Tag.exact_match(z_tags.join(" ")).map(&:id)
    
    ids = (tags_match + ids_match).uniq

    tags = Tag.readable(current_user).includes({:active_deployment => {:study => :user}}).where(:id => ids)

    render :json => tags.as_json({
                      :only => [:id, :code, :code_space, :manufacturer, :serial, :model]
                    })
  end

end
