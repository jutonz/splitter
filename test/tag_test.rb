require 'test_helper'

describe Splitter::Tag do
  before do
    @file          = 'test/mediafiles/beep.mp3'
    @file_backup   = 'test/mediafiles/beep_backup.mp3'
    FileUtils.rm @file_backup if File.exist? @file_backup
    FileUtils.cp @file, @file_backup
  end

  after do
    FileUtils.rm @file
    FileUtils.mv @file_backup, @file
  end

  it 'gets and sets album artist' do
    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      tag.album_artist = 'Bill Nye'
      f.save
    end

    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      assert_equal 'Bill Nye', tag.album_artist
    end
  end

  it 'gets and sets disc number' do
    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      tag.disc_number = 42
      f.save
    end

    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      assert_equal 42, tag.disc_number
    end
  end

  it 'gets and sets year' do
    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      tag.year = 1999
      f.save
    end

    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      assert_equal 1999, tag.year
    end
  end

  it 'gets and sets album' do
    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      tag.album = 'Best Eva'
      f.save
    end

    TagLib::MPEG::File.open(@file) do |f|
      tag = Splitter::Tag.new f.id3v2_tag
      assert_equal 'Best Eva', tag.album
    end
  end

end