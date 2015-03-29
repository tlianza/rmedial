class MediaPathsController < ApplicationController
  layout 'media'
 

  # GET /media_paths/new
  # GET /media_paths/new.xml
  def new
    @media_path = MediaPath.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @media_path }
    end
  end

  # GET /media_paths/1/edit
  def edit
    @media_path = MediaPath.find(params[:id])
  end

  # POST /media_paths
  # POST /media_paths.xml
  def create
    @media_path = MediaPath.new(params[:media_path])

    respond_to do |format|
      if @media_path.save
        flash[:notice] = 'MediaPath was successfully created.'
        format.html { redirect_to({:controller=>:rmedial_settings, :action=>:index}) }
        format.xml  { render :xml => @media_path, :status => :created, :location => @media_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @media_path.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /media_paths/1
  # PUT /media_paths/1.xml
  def update
    @media_path = MediaPath.find(params[:id])

    respond_to do |format|
      if @media_path.update_attributes(params[:media_path])
        flash[:notice] = 'MediaPath was successfully updated.'
        format.html { redirect_to({:controller=>:rmedial_settings, :action=>:index}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @media_path.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /media_paths/1
  # DELETE /media_paths/1.xml
  def destroy
    @media_path = MediaPath.find(params[:id])
    @media_path.destroy

    respond_to do |format|
      format.html { redirect_to({:controller=>:rmedial_settings, :action=>:index}) }
      format.xml  { head :ok }
    end
  end
  
  def import_media
    worker = MediaImportWorker.new
    Slave.fork{worker.import!} 
    flash[:notice] = 'Import has begun (in the background)'
    redirect_to({:controller=>:rmedial_settings, :action=>:index})
  end
  
  def symbol_url
    
  end
end
