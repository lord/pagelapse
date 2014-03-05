# Parses lapsefiles

module Pagelapse
  class Parser
    def initialize(file)
      @recorders = []
      instance_eval File.read(file), file, 1
      @threads = @recorders.map do |r|
        Thread.new { r.capture_loop }
      end
      @threads.each do |thread|
        thread.join
      end
    end

    def record(name, url)
      r = Pagelapse::Recorder.new(name, url)
      yield r
      @recorders << r
    end
  end
end