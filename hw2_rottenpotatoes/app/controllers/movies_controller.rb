class MoviesController < ApplicationController
  include ApplicationHelper
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    @all_ratings = Movie.select("DISTINCT rating").map(&:rating)
    # @movies = Movie.all
    searchArgs = Hash.new
    order = ""
    # if sessions exists and params doesn't have keys :ratings or :sort
    # AND params :ratings exists but doesn't have any keys, redirect_to the 
    # movie_link_path(:ratings => session[:ratings], :sort => session[:sort])
    # don't forget your flash.keep before redirect
    if params.has_key?(:ratings)
      showRatings = params[:ratings].keys
      searchArgs[:conditions] = [" rating in (?) ", showRatings]
    end
    searchArgs[:order] = params[:sort] if params.has_key?(:sort)
    @movies = Movie.find(:all, searchArgs)
    @titleClass = "hilite" if params[:sort] == "title"
    @dateClass = "hilite" if params[:sort] == "release_date"
    # save the filter and sort parameters in session[]
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
