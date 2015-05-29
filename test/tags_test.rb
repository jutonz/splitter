require 'test_helper'
require 'taglib'

describe Splitter::Tags do
  before do
    @tags = Splitter::Tags
  end

  it 'applies tags to a single file' do
    file = 'test/mediafiles/beep.mp3'
    expected_tags = Hash.new
    expected_tags[:genre] = 'Hardcore Disco'
    Splitter::Tags.apply expected_tags, to: file

    TagLib::FileRef.open(file) do |fileref|
      unless fileref.null?
        actual_tag = fileref.tag
        assert_equal actual_tag.genre, expected_tags[:genre]
      end
    end
  end

  it 'applies tags to multiple files' do
    files = []
    files.push 'test/mediafiles/beep.mp3'
    files.push 'test/mediafiles/beep_2.mp3'

    expected_tags = Hash.new
    expected_tags[:genre] = 'Hardcore Disco'
    Splitter::Tags.apply expected_tags, to: 'test/mediafiles'

    files.each do |file|
      TagLib::FileRef.open(file) do |fileref|
        unless fileref.null?
          actual_tag = fileref.tag
          assert_equal actual_tag.genre, expected_tags[:genre]
        end
      end
    end
  end
end