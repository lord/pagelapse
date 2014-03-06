require 'fileutils'
module Pagelapse
  class Recorder
    attr_accessor :interval, :duration, :timeout, :width, :height, :expiration
    attr_reader :name, :url

    def initialize(name, url)
      @name = name
      @url = url
      @interval = 20
      @duration = nil
      @on_load = nil
      @expiration = nil
      @start = Time.now
      @width = 1240
      @height = 900
      @timer = Time.new 0
      @capture_if = nil
      @save_if = nil
      FileUtils.mkdir_p(File.join 'lapses', @name)
    end

    def before_capture(&block)
      @on_load = block
    end

    def capture_if(&block)
      @capture_if = block
    end

    def save_if(&block)
      @save_if = block
    end

    def filename
      File.join 'lapses', @name, "#{Time.now.to_i}.png"
    end

    # Returns true if timer is expired and ready to capture
    def ready?
      @timer < Time.now - @interval
    end

    # Returns true if recorder has expired
    def expired?
      Time.now > @start + @expiration if @expiration
    end

    def capture
      @timer = Time.now
      ws = Pagelapse::Screenshot.new
      if @on_load
        ws.start_session(&@on_load)
      else
        ws.start_session
      end.capture(
        @url,
        filename,
        width: @width,
        height: @height,
        timeout: @timeout,
        capture_if: @capture_if,
        save_if: @save_if
      )
    end
  end
end
