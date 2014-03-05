require 'fileutils'
module Pagelapse
  class Recorder
    attr_accessor :interval, :duration, :timeout, :width, :height

    def initialize(name, url)
      @name = name
      @url = url
      @interval = 20
      @duration = nil
      @on_load = nil
      @timeout = nil
      @width = 1240
      @height = 900
      FileUtils.mkdir_p(File.join 'lapses', @name)
    end

    def on_load(&block)
      @on_load = block
    end

    def filename
      File.join 'lapses', @name, "#{Time.now.to_i}.png"
    end

    def capture
      ws = Pagelapse::Screenshot.new
      if @on_load
        ws.start_session(&@on_load)
      else
        ws.start_session
      end.capture(@url, filename, width: @width, height: @height, timeout: @timeout)
      true
    end

    def capture_loop
      while true
        capture
        sleep @interval
      end
    end
  end
end
