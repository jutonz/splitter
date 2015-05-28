require 'splitter/version.rb'
require 'fileutils'
require 'rubycue'

module Splitter 
  class Splitter
    attr_accessor :file_to_split, :cuefile

    def initialize(file_to_split, cuefile)
      fail_unless_exist file_to_split, cuefile
      enforce_format file_to_split, 'mp3'
      enforce_format cuefile, 'cue'

      self.file_to_split = file_to_split
      self.cuefile = cuefile
    end

    def self.detect_radioshow(cuefile)
      cuesheet = RubyCue::Cuesheet.new(File.read(cuefile))
      cuesheet.parse!

      title = cuesheet.title
      return :asot if title.downcase.start_with? 'a state of trance'

      return :generic
    end

    private

    def fail_unless_exist(*files)
      files.each { |file| fail_unless_exists file }
    end

    def fail_unless_exists(file)
      raise "The file #{file} doesn't exist" unless File.exist? file
    end

    def enforce_format(file, format)
      raise "The file #{file.path} must be a #{format}" unless file.path.end_with? format
    end

  end
end
