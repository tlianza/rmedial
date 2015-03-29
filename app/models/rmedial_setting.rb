class RmedialSetting < ActiveRecord::Base
  
  DEFAULT_STATIC_FILE_PATH = "#{RAILS_ROOT}/public/uploads"
  
  def self.default
    self.find(:first) || self.create(:path_to_ffmpeg=>find_ffmpeg_path)
  end
  
  def static_file_path
    attr = read_attribute(:static_file_path)
    attr.blank? ? DEFAULT_STATIC_FILE_PATH : attr
  end
  
  def self.find_ffmpeg_path
    which_ffmpeg = IO.popen("which ffmpeg")  
    ffmpeg_path = which_ffmpeg.readlines
    ffmpeg_path.size != 1 ? '/opt/local/bin/ffmpeg' : ffmpeg_path[0].strip
  end
end
