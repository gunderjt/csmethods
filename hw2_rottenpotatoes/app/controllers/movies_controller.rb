class MoviesController < ApplicationController
  include ApplicationHelper
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.select("DISTINCT rating").map {|i| i.rating}

    searchArgs = Hash.new
    redirectArgs = Hash.new
    order = ""
    no_redirect = 0

    # if sessions exists and params doesn't have keys :ratings or :sort
    # AND params :ratings exists but doesn't have any keys, redirect_to the
    # movie_link_path(:ratings => session[:ratings], :sort => session[:sort])
    # don't forget your flash.keep before redirect
    #    if params.has_key?(:ratings)
    if params[:ratings]
      showRatings = params[:ratings].keys
      searchArgs[:conditions] = [" rating in (?) ", showRatings]
      session[:ratings] = params[:ratings]
      session.delete(:sort)
      no_redirect = 1
    end
    #    if params.has_key?(:sort)
    if params[:sort]
#      debugger
      searchArgs[:order] = params[:sort]
      session[:sort] = params[:sort]
      unless params.has_key?(:ratings)
        session.delete(:ratings)
      end
      no_redirect = 1
    end
    if (no_redirect == 0 && (session.has_key?(:sort) || session.has_key?(:ratings)))
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
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
