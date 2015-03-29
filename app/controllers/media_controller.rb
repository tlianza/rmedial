class MediaController < ApplicationController
  
  #plays a media file
  def play
    @media = Medium.find(params[:id])
    send_file(@media.file_name)
  end
end
