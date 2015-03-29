require File.dirname(__FILE__) + '/../test_helper'

class ArtistTest < ActiveSupport::TestCase
  
  def test_filter
    j_songs = Artist.find_by_first_letter('J')
    assert_equal(1, j_songs.size)
    
    #lowercase shoudl be the same
    assert_equal(j_songs, Artist.find_by_first_letter('j'))
    
    #don't allow crappy input
    assert_raise RuntimeError do
      Artist.find_by_first_letter('some long sql')
    end
    
    #special case for numeric songs
    numeric_songs = Artist.find_by_first_letter('#')
    assert_equal(1, numeric_songs.length)
    assert_equal(artists(:two), numeric_songs[0])
  end
  
  def test_first_letter
    assert_equal('J', artists(:one).first_letter)
    assert_equal('#', artists(:two).first_letter)
  end
  
  def test_adjust_name
    artist = Artist.create(:name=>'Mountain Goats ')
    assert_equal('Mountain Goats', artist.name)
  end
  
  def test_create_prefix
    artist = Artist.create!(:name=>'The Troggs')
    assert_equal(artist.name, 'Troggs')
    assert_equal('The', artist.prefix)
    
    artist = Artist.create!(:name=>'They were great')
    assert_nil(artist.prefix)
    
    artist = Artist.create!(:name=>'Band of The Horses')
    assert_nil(artist.prefix)
    assert_equal('Band of The Horses', artist.name)
    
    artist = Artist.create!(:name=>'the band')
    assert_equal('the', artist.prefix)
    assert_equal('band', artist.name)
    
    
    artist = Artist.create!(:name=>'a tribe called quest')
    assert_equal('a', artist.prefix)
    assert_equal('tribe called quest', artist.name)
    
    artist = Artist.create!(:name=>'bond, the')
    assert_equal('the', artist.prefix)
    assert_equal('bond', artist.name)
    
    artist = Artist.create!(:name=>'zoo,the')
    assert_equal('the', artist.prefix)
    assert_equal('zoo', artist.name)
  end
  
  def test_find_or_create_by_name
    troggs = Artist.create!(:name=>'The Troggs')
    assert_equal(troggs, Artist.find_or_create_by_name!('The Troggs'))
    assert_equal(troggs, Artist.find_or_create_by_name!('troggs'))
    assert_equal(troggs, Artist.find_or_create_by_name!('The Troggs '))
    assert_equal(troggs, Artist.find_or_create_by_name!(' the troggs '))
    
    #decided to disallow this as a different band
    a_troggs = Artist.find_or_create_by_name!('a troggs')
    assert_equal(troggs, a_troggs)
    
    zeppelin = Artist.create!(:name=>'Led Zeppelin')
    assert_equal(zeppelin, Artist.find_or_create_by_name!('Led Zeppelin'))
    assert_equal(zeppelin, Artist.find_or_create_by_name!('led zeppelin'))
    assert_equal(zeppelin, Artist.find_or_create_by_name!(' led zeppelin '))
    
    assert_raise ArgumentError do
      Artist.find_or_create_by_name!(nil)
    end
    
    bjork = Artist.find_or_create_by_name!('Björk')
    assert_equal(bjork, Artist.find_or_create_by_name!('Björk'))
    assert_equal(bjork, Artist.find_or_create_by_name!(' Björk '))
    assert_equal(bjork, Artist.find_or_create_by_name!('björk'))
    assert_equal(bjork, Artist.find_or_create_by_name!("Björk\n"))
  end
  
  def test_validation
    Artist.create!(:name=>'Jos')
    assert_raise ActiveRecord::RecordInvalid do
      Artist.create!(:name=>'Jos')
    end
    assert_raise ActiveRecord::RecordInvalid do
      Artist.create!(:name=>'Jos ')
    end
    assert_raise ActiveRecord::RecordInvalid do
      Artist.create!(:name=>' jos ')
    end
  end
end
