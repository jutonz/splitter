require 'test_helper'

class SplitterText < Test::Unit::TestCase

  def setup
    @tempfile = Tempfile.new ['temp', '.cue']
    @splitter = Splitter::Splitter.new @tempfile
  end

  def tear_down
    @tempfile.close
  end

  def test_initialize_with_good_file
    splitter = Splitter::Splitter.new @tempfile
    assert_equal splitter.file_to_split, @tempfile
  end

  def test_initialize_with_bad_file
    assert_raise do 
      splitter = Splitter::Splitter.new 'doesnt_exist'
    end
  end

  def test_initialize_with_no_file
    assert_raise do
      splitter = Spliter::Splitter.new
    end
  end

end