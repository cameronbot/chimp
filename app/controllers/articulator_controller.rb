class ArticulatorController < ApplicationController
  def index
    @articles = Article.all(select: "id, headline, url")
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
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update_attributes(params[:article])
      flash[:notice] = "The monkeys saved your changes..."
      redirect_to articulator_index_path
    else
      flash[:alert] = "The monkeys had some problems..."
      render :show
    end
  end
end
