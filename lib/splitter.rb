require 'splitter/version.rb'

module Splitter 
  class Splitter
    attr_accessor :file_to_split, :cuefile

    def initialize(file_to_split, cuefile)
      fail_unless_exist file_to_split, cuefile

      self.file_to_split = file_to_split
      self.cuefile = cuefile
    end

    private

    def fail_unless_exist(*files)
      files.each { |file| fail_unless_exists file }
    end

    def fail_unless_exists(file)
      raise "The file #{file} doesn't exist" unless File.exist? file
    end

  end
end
