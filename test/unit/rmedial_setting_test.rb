require File.dirname(__FILE__) + '/../test_helper'

class RmedialSettingTest < ActiveSupport::TestCase
  def test_create_default
    RmedialSetting.delete_all
    assert_not_nil(RmedialSetting.default.path_to_ffmpeg)
    assert(RmedialSetting.default.path_to_ffmpeg =~ /ffmpeg/, "Path to ffmpeg looks wrong: #{RmedialSetting.default.path_to_ffmpeg} ")
  end
  
  
  
end
