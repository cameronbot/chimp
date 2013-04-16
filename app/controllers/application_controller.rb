class ApplicationController < ActionController::Base
  protect_from_forgery

  def tags
    context = params[:context] || "tags"

    if params[:query].present?
      where_clause = "taggings.context like \"%#{context}%\" and name like \"%#{params[:query]}%\""
    else
      where_clause = "taggings.context like \"%#{context}%\""
    end

    @tags = ActsAsTaggableOn::Tag.includes(:taggings).
      where(where_clause)

    @tags.map! { |t| t.name }

    # if params[:query].present?
    #   @tags = @tags.find_all{ |t| t =~ /#{params[:query]}/ }
    # end

    render :json => @tags
  end
end
