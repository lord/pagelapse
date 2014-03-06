require "capybara/dsl"
require "capybara/poltergeist"

module Pagelapse
  # Thanks to http://www.cherpec.com/2013/04/30/capturing-web-page-screenshots-from-ruby/
  # for the basis of this code
  class Screenshot
    include Capybara::DSL

    # Captures a screenshot of +url+ saving it to +output_path+.
    def capture(url, output_path, width: 1024, height: 768, full: false, timeout: false, capture_if: nil)
      # Browser settings
      page.driver.resize(width, height)
      page.driver.headers = {
        "User-Agent" => "Pagelapse #{Pagelapse::VERSION}",
      }

      unless capture_if
        capture_if = Proc.new do
          page.driver.status_code == 200
        end
      end

      # Open page
      visit url

      # Timeout
      sleep timeout if timeout

      if instance_eval(&capture_if)
        # Save screenshot
        page.driver.save_screenshot(output_path, :full => full)
        true
      else
        false
      end
    end

    def start_session(&block)
      Capybara.reset_sessions!
      Capybara.current_session.instance_eval(&block) if block_given?
      self
    end
  end

  # By default Capybara will try to boot a rack application
  # automatically. You might want to switch off Capybara's
  # rack server if you are running against a remote application
  Capybara.run_server = false
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {
      # Raise JavaScript errors to Ruby
      js_errors: false,
      phantomjs_logger: File.open(File::NULL, "w"),
      debug: false,
      # Additional command line options for PhantomJS
      phantomjs_options: ['--ignore-ssl-errors=yes'],
    })
  end
  Capybara.current_driver = :poltergeist
end
