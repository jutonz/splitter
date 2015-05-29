require 'rubycue'
require 'when_was'
require 'yaml'

module Splitter
  class StandardsEnforcer
    STANDARDS_FILE = 'lib/splitter/standards.yml'

    attr_accessor :mediafile, :cuesheet, :standards
    attr_accessor :performer, :title

    def initialize(mediafile, cuesheet)
      @mediafile = File.open mediafile
      @cuesheet  = parse! cuesheet
      @standards = YAML.load_file STANDARDS_FILE
    end

    def parse!(cuesheet)
      cuesheet = RubyCue::Cuesheet.new(File.read(cuesheet))
      cuesheet.parse!

      @performer   = cuesheet.performer
      @title = cuesheet.title

      return cuesheet
    end

    def output_folder
      format = standards['global']['folder_name']
      format.gsub! '%ep_number', episode_number
      folder = airdate.strftime format
      return File.join(File.dirname(mediafile), folder)
    end

    def track_format
      @standards['track']['track_format']
    end

    def airdate
      WhenWas.ASOT episode_number
    end

    def episode_number
      if @cuesheet.title.start_with? 'A State of Trance'
        return ep_number = /Trance \d{3,}/.match(title)[0].split(' ')[1]
      end
    end

    def album_title
      title = @cuesheet.title
      if title.start_with? 'A State of Trance'
        ep_number = /\d{3}/.match(title)[0]
        return "A State of Trance #{ep_number}"
      end
      return title
    end

    def appropriate_tags
      tags = Hash.new
      tags[:album_artist] = standards['global']['album_artist']
      tags[:album_title]  = album_title
      tags[:genre]        = standards['global']['genre']
      tags[:year]         = airdate.year
      tags[:disc_number]  = standards['global']['disc_number']
      return tags
    end
  end
end