class ArticulatorController < ApplicationController
  def index

    conditions = {}
    if params[:limit]
      case params[:limit].downcase
      when "today"
        conditions = { :updated_at => Date.today...Date.today+2 }
      when "yesterday"
        conditions = { :updated_at => Date.today-1...Date.today }
      when "week"
        conditions = { :updated_at => Date.today-7...Date.today+1 }
      when "unreported"
        conditions = { :report_id => nil }
      else
        conditions = { :updated_at => Date.today...Date.today+2 }
      end
    end

    @articles = Article.all(select: "id, headline, url, created_at, publication_id, report_id",
      include: [ :publication ],
      conditions: conditions)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])

    if @article.monkey_work!
      flash[:notice] = I18n.t 'parse_article.flash.success'
      redirect_to articulator_path(@article)
    else
      flash[:alert] = I18n.t 'parse_article.flash.error'
      render :new
    end
  end

  def show
    @article = Article.find(params[:id], include: [ :publication ])
    unless @article.matches.nil?
      @article.matches = JSON.parse(@article.matches);
    end
  end

  def update
    @article = Article.find(params[:id], include: [ :publication ])

    if @article.publication.formatted_name != params[:article][:publication]
      @article.publication.update_attributes({ formatted_name: params[:article][:publication] })
    end

    params[:article].delete(:publication)

    if params[:article][:date].present?
      params[:article][:date] = Date.strptime(params[:article][:date], "%m/%d/%y")
    end

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
