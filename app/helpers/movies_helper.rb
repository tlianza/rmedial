module MoviesHelper
  def thumbnail_uri(movie)
    return movie.thumbnail_uri || url_for({:action=>:show_thumbnail, :id=>movie.id}) if movie.has_thumbnail?
    image_path('dvd.png')
  end
  
  def play_uri(movie)
    url_for({:controller=>:media, :action=>:play, :id=>movie.id})
  end
  
  def play_flash_uri(movie)
     movie.encoded_uri || url_for({:controller=>:movies, :action=>:play, :id=>movie.id})
  end
end
