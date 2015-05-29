require 'taglib'

module Splitter
  class Tag < TagLib::ID3v2::Tag
    attr_accessor :base_tag

    def initialize(id3v2_tag)
      @base_tag = id3v2_tag
    end

    def album_artist
      alb_artist = base_tag.frame_list('TPE2').first
      return alb_artist.nil? ? nil : alb_artist.to_s
    end

    def album_artist=(other)
      return if other.nil?
      set_or_create_text_frame 'TPE2', other
    end

    def disc_number
      tag = base_tag.frame_list('TPOS').first
      return tag.nil? ? nil : tag.to_s.to_i
    end

    def disc_number=(other)
      return if other.nil?
      set_or_create_text_frame 'TPOS', "#{other}"
    end

    def genre=(other)
      return if other.nil?
      base_tag.genre = other
    end

    def album
      base_tag.album
    end

    def album=(other)
      return if other.nil?
      base_tag.album = other
    end

    def year 
      base_tag.year
    end

    def year=(other)
      return if other.nil?
      base_tag.year = other
    end

    def set_or_create_text_frame(frame_id, frame_value, encoding = TagLib::String::UTF8)
      return if frame_id.nil? or frame_value.nil? or base_tag.nil?
      frame = base_tag.frame_list(frame_id).first
      if frame.nil?
        frame = TagLib::ID3v2::TextIdentificationFrame.new frame_id, encoding
        creating_now = true
      end
      frame.text = frame_value
      base_tag.add_frame frame if creating_now
    end
  end
end