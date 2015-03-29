#This is the class that should be insantiated to do media importing.  It 
#establishes it's own database connection so it can be used outside of
#the rails process.
class MediaImportWorker
  
  def initialize
    ActiveRecord::Base.establish_connection
  end

  def import!
    begin
      Medium.import!
    rescue
      LastImportError.create(:error=>$!)
    rescue MissingSourceFile
      LastImportError.create(:error=>$!) 
    end
  end
  
  def transcode_movie(movie)
    movie.transcode!
  end
  
end