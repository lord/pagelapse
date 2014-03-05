module Pagelapse
  class Recorder
    attr_accessor :interval, :duration, :timeout, :width, :height

    def initialize(url)
      @interval = 20
      @duration = nil
      @url = url
      @on_load = nil
      @timeout = nil
      @width = 1240
      @height = 900
    end

    def on_load(&block)
      @on_load = block
    end

    def capture
      ws = Webshot::Screenshot.instance
      @sizes.each do |size_name, size|
        if @on_load
          ws.start_session(&@on_load)
        else
          ws
        end.capture(@url, "#{size_name}.png", width: @width, height: @height, timeout: @timeout)
      end
      true
    end
  end
end
