require 'splitter/version'
require 'splitter/exceptions'
require 'splitter/replay_gain'
require 'splitter/tags'
require 'splitter/standards_enforcer'
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

    def split!(options = {})
      output_folder = options[:to]
      if File.exist? output_folder
        if options[:force]
          FileUtils.rm_r output_folder
        else
          raise OutputFolderExists.new output_folder
        end
      end
      split_to! output_folder, options
    end

    def split_to!(output_folder, options = {})
      opts = Hash.new
      opts[:quiet] = true
      opts[:output_folder] = output_folder
      opts[:report_progress_to] = options[:report_progress_to]
      opts[:format] = options[:format] if options[:format]

      if File.exist? output_folder
        raise OutputFolderExists.new output_folder
      end

      splitter = CueSnap::Splitter.new file_to_split, cuefile, opts
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
      raise "The file #{file.path} must be of type #{format}" unless File.extname(file) == format
    end

  end
end
