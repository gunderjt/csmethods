class MoviesController < ApplicationController
  include ApplicationHelper
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    @all_ratings = Movie.select("DISTINCT rating").map(&:rating)
    @movies = Movie.all
    searchArgs = Hash.new
    showRatings = params[:ratings].keys if defined? params[:ratings]
    order = params[:type] if defined? params[:type]
    searchArgs[:order] = order if defined? order
    searchArgs[:conditions] = [" ratings = ? ", showRatings] if defined? showRatings
    @movies = Movie.all(searchArgs)
    @titleClass = "hilite" if order == "title"
    @dateClass = "hilite" if order == "release_date"
    # order = params[:type]
    # @movies = Movie.find(:all, :order => order) if defined? order
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

  def filter
    searchArgs = Hash.new
    showRatings = params[:ratings].keys
    order = params[:type]
    searchArgs[:order] = order if defined? order
    searchArgs[:conditions] = [" ratings = ? ", showRatings] if defined? showRatings
   # @movies = Movie.where("ratings = ?", showRatings)
    @movies = Movie.all(searchArgs)
  end
end
