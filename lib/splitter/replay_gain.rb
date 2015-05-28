require 'pty'
require 'ruby-progressbar'

module Splitter
  class ReplayGain
    def self.apply_album_gain(directory)
      Dir.chdir directory
      files = Dir["#{directory}/*.mp3"]
      progress = ProgressBar.create title: "ReplayGain"
      progress.total = files.length * 2
      cmd = "mp3gain -a *.mp3"
      begin
        PTY.spawn(cmd) do |stdout, stdin, pid|
          begin
            stdout.each { |line| progress.increment }
          rescue Errno::EIO
            progress = 100
          end
        end
      rescue PTY::ChildExited
        puts "finished calculating replaygain" 
      end
    end
  end

end