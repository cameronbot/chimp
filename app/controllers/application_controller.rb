class ApplicationController < ActionController::Base
  protect_from_forgery

  def tags
    context = params[:context] || "tags"

    if params[:query].present?
      @tags = Article.tag_counts_on(context).where("name like \'%#{params[:query]}%\'")
    else
      @tags = Article.tag_counts_on(context)
    end

    @tags.map! { |t| t.name }

    render :json => @tags
  end
end
