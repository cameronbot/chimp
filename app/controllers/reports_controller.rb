class ReportsController < ApplicationController
  def index
    @reports = Report.all(include: [ :article ])
  end

  def new
    @report = Report.new
  end

  def create
    @report = Report.create
    params[:article_ids].each_with_index do |id, index|
      Article.find(id).update_attributes({ report_id: @report.id, position: index+1 })
    end
    redirect_to report_path @report
  end

  def edit
    @report = Report.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])
  end

  def show
    @report = Report.find(params[:id])
    @articles = @report.article.order(:position)
  end

  def sort
    params[:article].each_with_index do |id, index|
      Article.update_all({ position: index+1} , { id: id })
    end
    render nothing: true
  end
end
