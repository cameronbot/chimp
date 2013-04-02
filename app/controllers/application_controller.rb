class ApplicationController < ActionController::Base
  protect_from_forgery

  def tags
    context = params[:context] || "tags"
    @tags = ActsAsTaggableOn::Tag.includes(:taggings).
      where("taggings.context = \"#{context}\"")

    @tags.map! { |t| t.name }

    if params[:query].present?
      @tags = @tags.find_all{ |t| t =~ /#{params[:query]}/ }
    end

    render :json => @tags
  end
end
