class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.find_ratings
    @ratings_checked = @all_ratings.dup

    if !params[:sort].nil?
      session[:current_sort] = params[:sort]
    else
      if !session[:current_sort].nil?
        redirect_to :ratings => params[:ratings], :sort => session[:current_sort]
        return
      end
    end

    if !params[:ratings].nil? || !params[:commit].nil?
      @ratings_checked = params[:ratings].keys unless params[:ratings].nil?
      session[:current_ratings] = params[:ratings] unless params[:ratings].nil?
    else
     if !session[:current_ratings].nil?
        redirect_to :ratings => session[:current_ratings], :sort => params[:sort]
        return
      end
    end

    if !session[:current_sort].nil?
       @movies = Movie.order(session[:current_sort]).find(:all, :conditions => {:rating => @ratings_checked})
    else
       @movies = Movie.find(:all, :conditions => {:rating => @ratings_checked})
    end

    if session[:current_sort].nil? && session[:current_ratings].nil?
      @movies = Movie.find(:all)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path :sort => session[:current_sort], :ratings => session[:current_ratings]
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
    redirect_to movies_path :sort => session[:current_sort], :ratings => session[:current_ratings]
  end

end
