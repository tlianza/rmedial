class SongsController < ApplicationController
  layout 'media'

  # GET /songs/1
  # GET /songs/1.xml
  def show
    @song = Song.find(params[:id], :include=>[:artist, :album])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end


  # DELETE /songs/1
  # DELETE /songs/1.xml
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to(songs_url) }
      format.xml  { head :ok }
    end
  end
end
