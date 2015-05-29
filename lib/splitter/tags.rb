require 'splitter/tag'
require 'taglib'
require 'rubycue'

module Splitter
  class Tags
    # def self.adjust_tags_for(directory, options)
    #   @directory    = directory
    #   @progress_bar = options[:report_progress_to]
    #   @cuefile      = Tags.load_cuefile options[:using]

    #   files = Tags.load_files @directory
    #   @progress_bar.total = files.length unless @progress_bar.nil?

    #   tags = Hash.new
    #   tags[:album_artist] = 'Various Artists'
    #   tags[:year]         = 2015
    #   tags[:genre]        = 'Trance'
    #   Tags.apply_tags tags, to: files
    # end

    # def self.load_cuefile(cuefile)
    #   cuesheet = RubyCue::Cuesheet.new(File.read(cuefile))
    #   cuesheet.parse!
    #   return cuesheet
    # end

    def self.get_files(from_directory, target_ext = '.mp3')
      Dir["#{from_directory}/*#{target_ext}"]
    end

    # def self.apply_tags(tags, options)
    #   raise 'Must specify files to which tags will be applied' if options[:to].nil?
    #   options[:to].each do |file|
    #     TagLib::MPEG::File.open(file) do |f|
    #       tag = Tag.new f.id3v2_tag

    #       tag.genre        = tags[:genre]
    #       tag.album        = tags[:album_title]
    #       tag.year         = tags[:year] 
    #       tag.album_artist = tags[:album_artist]

    #       f.save
    #       @progress_bar.increment unless @progress_bar.nil?
    #     end
    #   end
    # end

    def self.apply(tags, options = {})
      return if options[:to].nil?

      files = options[:to]
      files = File.directory?(files) ? Tags.get_files(files) : [files] 

      progress       = options[:report_progress_to]
      progress.total = files.length unless progress.nil?

      files.each do |file|
        TagLib::MPEG::File.open(file) do |f|
          tag = Tag.new f.id3v2_tag

          tag.genre        = tags[:genre]
          tag.album        = tags[:album_title]
          tag.year         = tags[:year] 
          tag.album_artist = tags[:album_artist]

          f.save
          progress.increment unless progress.nil?
        end
      end 
    end

  end
end