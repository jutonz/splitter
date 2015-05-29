require 'test_helper'

describe Splitter::StandardsEnforcer do

  before do 
    @tempmedia = Tempfile.new ['temp', '.mp3']
    @cuesheet  = 'test/cues/asot714.cue'
    @standards = Splitter::StandardsEnforcer.new @tempmedia, @cuesheet
  end

  it 'loads from standards.yml' do
    assert_equal 'lib/splitter/standards.yml', Splitter::StandardsEnforcer::STANDARDS_FILE
  end

  it 'remembers the mediafile' do
    assert_equal @tempmedia.path, @standards.mediafile.path
  end

  it 'autoloads the performer from the cuefile' do
    assert_equal "Armin van Buuren", @standards.performer
  end

  it 'autloads the title from the cuefile' do
    assert_equal "A State of Trance 714 (2015-05-21) (SBD)", @standards.title
  end

  it 'correctly determines the output folder' do
    assert_equal '/tmp/714 (21 May 2015)', @standards.output_folder
  end

  it 'correctly determines the album title' do
    assert_equal 'A State of Trance 714', @standards.album_title
  end

  it 'defaults to the title in the cue for album title' do
    @cuesheet  = 'test/cues/generic.cue'
    @standards = Splitter::StandardsEnforcer.new @tempmedia, @cuesheet
    assert_equal "generic title", @standards.album_title
  end

  it 'recommends appropriate tags' do
    expected = Hash.new
    expected[:genre]        = 'Trance'
    expected[:album_title]  = 'A State of Trance 714'
    expected[:album_artist] = 'Various Artists'
    expected[:year]         = 2015
    expected[:disc_number]  = 1
    assert_equal expected, @standards.appropriate_tags
  end

end