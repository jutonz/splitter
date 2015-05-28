require 'splitter/version.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

module Splitter 
  class Splitter
    attr_accessor :file_to_split, :cuefile

    def initialize(file_to_split, cuefile)
      raise "The file #{file_to_split} doesn't exist" unless File.exist? file_to_split

      self.file_to_split = file_to_split
      self.cuefile = cuefile
    end

  end
end
