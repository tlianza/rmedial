class Artist < ActiveRecord::Base
  has_many :songs, :order=>'year, track, title'
  has_many :albums, :order=>'year, name'
  
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :minimum=>1
  
  before_save :set_prefix
  
  attr_protected :prefix
  
  def self.find_by_first_letter(letter)
    raise "Must pass a single letter" if letter.blank? or letter.size != 1   
    whereclause = ('#' == letter) ? "name REGEXP'^[^a-z]'" : "name LIKE '#{letter}%'"
    
    self.find(:all, :conditions=>whereclause, :order=>'name')
  end
  
  #We have to override this for the sake of the prefix logic.  Given a name,
  #returns (or creates and returns) an artist.
  def self.find_or_create_by_name!(_name, param_hash={})
    raise ArgumentError, "Must specify an artist name" if _name.blank?
    prefix_array = Artist.split_name_prefix(_name)
    if !prefix_array[0].blank?
      artist = Artist.find_by_name(prefix_array[1])
      artist = Artist.create!({:name=>prefix_array[1]}.merge(param_hash)) if artist.nil?
    else
      artist = Artist.find(:first, :conditions=>['name=?', prefix_array[1]])
      artist = Artist.create!({:name=>prefix_array[1]}.merge(param_hash)) if artist.nil?
    end
    
    artist
  end
  
  def songs_without_album
    songs.find(:all, :conditions=>'album_id IS NULL')
  end
  
  def name=(_name)
    write_attribute(:name, _name.strip)
  end
  
  def display_name
    prefix.blank? ? name : prefix+' '+name
  end
  
  #For the sake of our navigation
  def first_letter
    char = name[0,1].upcase
    char =~ /[A-Z]/ ? char : '#'
  end
 
private
  #Sets the prefix on the artist's name so we can do smarter alphabetization
  def set_prefix
    prefix_array = Artist.split_name_prefix(name)
    
    #if we had a match, split the artist into prefix plus name
    if !prefix_array[0].blank?
      write_attribute(:prefix, prefix_array[0])
      write_attribute(:name, prefix_array[1])
    end
  end
  
  #given a name, returns an array in the form [prefix, name]
  def self.split_name_prefix(name)
    #mp3s seem to often wind up with a \000 character at the end of the artist name, which doesn't get stripped
    name = name.chars.sub("\000", '').strip
    
    #in the match object, where to find the name and prefix
    prefix_match = 1
    name_match = 2
    
    the_match = name.match(/^(the)\s(.*)/i)
    the_match = name.match(/^(a)\s(.*)/i) if !the_match
    
    #reverse the matches, since the name is now first
    if !the_match
      the_match = name.match(/(.*),\s?(the)$/i)
      
      prefix_match = 2
      name_match = 1
    end
    
    #if we found a prefix, return it
    if the_match
      return [the_match[prefix_match], the_match[name_match]]
    end 
    
    #no prefix, assume it's just a name
    [nil, name]
  end
end
