require File.dirname(__FILE__) + '/../test_helper'

class MediaPathTest < ActiveSupport::TestCase
  
  def test_validations
    assert_raise ActiveRecord::RecordInvalid do
      MediaPath.create!
    end
  end
end
