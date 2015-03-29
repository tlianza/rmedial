# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #get the current tab in all controllers (share the same layout)
  before_filter :set_current_tab, :set_stats
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c96c395ecc726d28bc80c92f688da7a2'
  
  #simple logic for setting the highlighted tab
  def set_current_tab
    @current_tab = :music
    case request.path_parameters[:controller]
      when :movies.to_s
        @current_tab = :movies
        
      when :media_paths.to_s
        @current_tab = :config
        
      when :rmedial_settings.to_s
        @current_tab = :config
        
    end
  end
  
  def set_stats
    @movie_count = Movie.count
    @song_count = Song.count
    @album_count = Album.count
  end
end
