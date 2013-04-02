class PublicationsController < ApplicationController
  def index
    @publications = Publication.all
  end

  def new
    @publication = Publication.new
  end

  def create
    @publication = Publication.new(params[:publication])

    if @publication.save!
      flash[:notice] = "Publication was created"
      redirect_to publications_path
    else
      flash[:alert] = "Problem saving publication"
      render :new
    end
  end

  def edit
    @publication = Publication.find(params[:id])
  end

  def update
    @publication = Publication.find(params[:id])

    if @publication.update_attributes(params[:publication])
      flash[:notice] = "Publication was updated"
      redirect_to publications_path
    else
      flash[:alert] = "Problem updating publication"
      render :edit
    end
  end

  def destroy
    @publication = Publication.find(params[:id])

    @publication.delete
    flash[:notice] = "#{@publication.formatted_name} was deleted."
    redirect_to publications_path
  end

end
