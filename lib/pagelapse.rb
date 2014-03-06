require "pagelapse/version"
require "pagelapse/recorder"
require "pagelapse/screenshot"
require "pagelapse/parser"
require "pagelapse/viewer"

module Pagelapse

  def self.cli(args)
    case args[0]
    when nil, 'start'
      begin
        Pagelapse::Parser.new "./Lapsefile"
      rescue Interrupt
      end
    when 'view', 'viewer', 'server'
      Pagelapse::Viewer.run!
    else
      puts "Unknown action #{args[0]}"
    end
  end
end
