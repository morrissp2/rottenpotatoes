class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    sort = params[:sort] || session[:sort]
    if sort == 'title'
      @movies = Movie.order(:title)
    elsif sort == 'release_date'
      @movies = Movie.order (:release_date)
    else	     		
      @movies = Movie.all
    end
    @sort_ratings = params[:ratings]	
    if @sort_ratings != nil 
#        @sort_ratings = @sort_ratings.keys 
	@movies = Movie.where(["rating IN (?)", @sort_ratings.keys]).all
    elsif 
        h = Hash.new
	Movie.all_ratings.each { | e | h[e] = "1" }
        @sort_ratings = h
    end
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
