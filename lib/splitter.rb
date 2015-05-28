require 'splitter/version'
require 'splitter/exceptions'
require 'splitter/replay_gain'
require 'fileutils'
require 'rubycue'
require 'when_was'
require 'cuesnap'

module Splitter 
  class Splitter
    attr_accessor :file_to_split, :cuefile

    def initialize(file_to_split, cuefile = nil)
      if cuefile.nil?
        file_ext = File.extname file_to_split
        cuefile = file_to_split.gsub(file_ext, '.cue')
      end
      fail_unless_exist file_to_split, cuefile
      enforce_format file_to_split, '.mp3'
      enforce_format cuefile, '.cue'

      self.file_to_split = file_to_split
      self.cuefile = cuefile
    end

    def split!
      split_to! Splitter.determine_output_folder(cuefile)
    end

    def split_to!(output_folder)
      options = Hash.new
      options[:quiet] = true
      options[:output_folder] = output_folder

      if File.exist? output_folder
        raise OutputFolderExists.new output_folder
      end

      splitter = CueSnap::Splitter.new file_to_split, cuefile, options
      splitter.split! 

      return output_folder
    end

    def split_dry_run
      output_folder = Splitter.determine_output_folder(cuefile)
      if File.exist? output_folder
        raise OutputFolderExists.new output_folder
      end
    end

    def self.determine_output_folder(cuefile)
      current_directory  = File.dirname(cuefile)
      output_folder_name = determine_output_folder_name(cuefile)
      File.join(current_directory, output_folder_name)
    end

    def self.determine_output_folder_name(cuefile)
      cuesheet = RubyCue::Cuesheet.new(File.read(cuefile))
      cuesheet.parse!

      title = cuesheet.title
      if title.start_with? 'A State of Trance'
        ep_number = /Trance \d{3,}/.match(title)[0].split(' ')[1]
        airdate = WhenWas.ASOT ep_number
        return airdate.strftime "#{ep_number} (%d %B %Y)"
      end

      return title
    end

    private

    def fail_unless_exist(*files)
      files.each { |file| fail_unless_exists file }
    end

    def fail_unless_exists(file)
      raise "The file #{file} doesn't exist" unless File.exist? file
    end

    def enforce_format(file, format)
      raise "The file #{file} must be a #{format}" unless File.extname(file) == format
    end

  end
end
