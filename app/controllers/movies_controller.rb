class MoviesController < ApplicationController
  layout 'media'
    
  # GET /movies
  # GET /movies.xml
  def index
    @folder_name = params[:folder_name]
    
    #either showing top folder, or subfolders
    if @folder_name.blank?
      @movies = Movie.find(:all, :conditions=>"folder_name IS NULL or folder_name=''", :order=>'title')
      @folders = Movie.find(:all, 
                            :select=>'folder_name, count(id) as movie_count',
                            :conditions=>"folder_name IS NOT NULL and folder_name <> ''", 
                            :group=>'folder_name', :order=>'folder_name, title')
    else
      @movies = Movie.find(:all, :conditions=>['folder_name=?', @folder_name], :order=>'folder_name, title')
      @folders = []
    end

    

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end
  
  def transcode
    @movie = Movie.find(params[:id])
    worker = MediaImportWorker.new
    Slave.fork{worker.transcode_movie(@movie)} 
    flash[:notice] = 'Movie conversion to Flash has begun (in the background)'
    redirect_to(movies_path)
  end
  
  def show_thumbnail
    @movie = Movie.find(params[:id])
    send_file(@movie.thumbnail_path, :type=>'image/jpeg')
  end
  
  def play
    @movie = Movie.find(params[:id])
    send_file(@movie.encoded_path)
  end

end
