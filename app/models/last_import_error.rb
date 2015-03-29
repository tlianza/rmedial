class LastImportError < ActiveRecord::Base
  def to_s
    error
  end
end
