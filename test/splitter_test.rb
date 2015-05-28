require 'test_helper'

describe Splitter do
  before do
    @tempfile = Tempfile.new ['temp', '.mp3']
    @tempcue  = Tempfile.new ['temp', '.cue']
    @splitter = Splitter::Splitter.new @tempfile, @tempcue
  end

  after do
    @tempfile.close
    @tempcue.close
  end 

  it 'remembers the file to be split' do
    assert_equal @splitter.file_to_split, @tempfile
  end

  it 'remembers the cuefile' do
    assert_equal @splitter.cuefile, @tempcue
  end

  it 'complains if the file to split does not exist' do
    assert_raises RuntimeError do
      Splitter::Splitter.new 'fakefile', @tempcue
    end
  end

  it 'complains if the cuefile does not exist' do
    assert_raises RuntimeError do
      Splitter::Splitter.new @tempfile, 'fake_cue'
    end
  end

end
