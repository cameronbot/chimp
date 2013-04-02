class ArticulatorController < ApplicationController
  def index
    @articles = Article.all(select: "id, headline, url, created_at, publication_id", include: [ :publication ])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])

    if @article.monkey_work!
      flash[:notice] = "The monkeys did some good work for you..."
      redirect_to articulator_path(@article)
    else
      flash[:alert] = "The monkeys had some problems..."
      render :new
    end
  end

  def show
    @article = Article.find(params[:id], include: [ :publication ])
  end

  def update
    @article = Article.find(params[:id], include: [ :publication ])

    if @article.publication.formatted_name != params[:article][:publication]
      @article.publication.update_attributes({ formatted_name: params[:article][:publication] })
    end

    params[:article].delete(:publication)

    if @article.update_attributes(params[:article])
      flash[:notice] = "The monkeys saved your changes..."
      redirect_to articulator_path(@article)
    else
      flash[:alert] = "The monkeys had some problems..."
      render :show
    end
  end

  def destroy
    @article = Article.find(params[:id])

    @article.delete
    flash[:notice] = "The article was deleted."
    redirect_to root_path
  end

  def summarize
    @articles = Article.find(params[:article_ids])
  end
end
