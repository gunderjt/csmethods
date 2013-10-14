class MoviesController < ApplicationController
  include ApplicationHelper
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    searchArgs = Hash.new
    redirectArgs = Hash.new
    order = ""
    redirect = true

    #get all the rating types that are in the database
    @all_ratings = Movie.select("DISTINCT rating").map {|i| i.rating}

    #check to see if user has entered in ratings: if so then
    #save it in the session, and make sure the flag indicates that
    #there should be no redirect, also delete other keys
    if params[:ratings]
      showRatings = params[:ratings].keys
      searchArgs[:conditions] = [" rating in (?) ", showRatings]
      session[:ratings] = params[:ratings]
      session.delete(:sort)
      redirect = false
    end

    #check to see if user has entered in a sorting type: if so then
    #save it in the session, and make sure the flag indicates that
    #there should be no redirect
    if params[:sort]
      searchArgs[:order] = params[:sort]
      session[:sort] = params[:sort]
      unless params.has_key?(:ratings)
        session.delete(:ratings)
      end
      redirect = false
    end

    #if user didn't enter in any parameters, check to see if there are
    #saved parameters and then redirect to that
    if (redirect && (session.has_key?(:sort) || session.has_key?(:ratings)))
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    #else render the view page as normal
    @movies = Movie.find(:all, searchArgs)
    #look in the ApplicationHelper folder for this code
    highliter(params[:sort]) if params.has_key?(:sort)
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
