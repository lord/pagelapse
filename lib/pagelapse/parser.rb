# Parses lapsefiles

module Pagelapse
  class Parser
    def initialize(file)
      puts "Starting Pagelapse #{Pagelapse::VERSION}"
      @recorders = []
      instance_eval File.read(file), file, 1
      while @recorders.length > 0 do
        @recorders.each do |r|
          if r.ready?
            print "Checking #{r.name}"
            if r.capture
              puts " - captured!"
            else
              puts ""
            end
          end
        end
        @recorders.reject! do |r|
          r.expired?
        end
      end
    end

    def record(name, url, interval=20)
      r = Pagelapse::Recorder.new(name, url)
      yield r
      @recorders << r
    end
  end
end