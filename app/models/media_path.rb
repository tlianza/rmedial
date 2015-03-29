class MediaPath < ActiveRecord::Base
  
  #Relationships
  has_many :media, :dependent=>:destroy
  
  #Validations
  validates_presence_of :filesystem_path
  validates_uniqueness_of :filesystem_path
  
  #make sure the path always has a trailing slash
  def normalized_path
    return filesystem_path if filesystem_path[filesystem_path.size-1] == '/'
    return filesystem_path+'/'
  end
end
