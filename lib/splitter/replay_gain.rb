require 'pty'
require 'ruby-progressbar'
require 'thread'
require 'facter'

module Splitter
  class ReplayGain
    attr_accessor :directory, :files

    def apply_album_gain(options = {})
      return if options[:to].nil?

      @directory = options[:to]
      @files     = get_files_from directory

      progress       = options[:report_progress_to]
      progress.total = files.length unless progress.nil?

      Dir.chdir directory
      work_queue = Queue.new
      files.each do |file| work_queue.push file end
      cores = Facter.value('processors')['count']
      workers = (0...cores).map do
        Thread.new do
          begin
            while file = work_queue.pop(true) # raise if queue.pop not true
              apply_track_gain to: file
              progress.increment unless progress.nil?
            end
          rescue ThreadError
          end
        end
      end
      workers.map(&:join)

    end

    def apply_track_gain(options = {})
      return if options[:to].nil?

      track = options[:to]
      cmd = "mp3gain \"#{track}\""
      begin
        PTY.spawn(cmd) do |stdout, stdin, pid|
          begin
            stdout.each { |line| }
          rescue Errno::EIO
          end
        end
      rescue PTY::ChildExited
      end
    end

    def get_files_from(from_directory, target_ext = '.mp3')
      Dir["#{from_directory}/*#{target_ext}"]
    end
  end

end