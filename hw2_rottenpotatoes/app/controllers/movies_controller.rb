class MoviesController < ApplicationController
  include ApplicationHelper
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.select("DISTINCT rating").map(&:rating)
    @movies = Movie.all
    order = params[:type]
    @titleClass = "hilite" if order == "title"
    @dateClass = "hilite" if order == "release_date"

    @movies = Movie.find(:all, :order => order) if defined? order
    # @movies = Movie.find(:all, :order => "title") if order == "title"
    # @movies = Movie.find(:all, :order => "release_date") if order == "date"
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
