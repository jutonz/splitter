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

  it 'complains if the file to split is not an mp3' do
    temppdf = Tempfile.new ['temp', '.pdf']
    err = assert_raises RuntimeError do
      Splitter::Splitter.new temppdf, @tempcue
    end
    assert_equal err.message, "The file #{temppdf.path} must be a mp3"
  end

  it 'complains if the cuefile does not exist' do
    assert_raises RuntimeError do
      Splitter::Splitter.new @tempfile, 'fake_cue'
    end
  end

  it 'complains if the cuefile is not actually a cuefile' do
    temppdf = Tempfile.new ['temp', '.pdf']
    err = assert_raises RuntimeError do 
      Splitter::Splitter.new @tempfile, temppdf
    end
    assert_equal err.message, "The file #{temppdf.path} must be a cue"
  end

  describe '.determine_output_location' do
    it 'detects ASOT' do
      cuesheet = 'test/cues/asot714.cue'
      assert_equal "714 (21 May 2015)", Splitter::Splitter.determine_output_location(cuesheet)
    end

    it 'defaults to the title in the cuefile' do
      cuesheet = 'test/cues/generic.cue'
      assert_equal 'generic title', Splitter::Splitter.determine_output_location(cuesheet)
    end
  end

end
