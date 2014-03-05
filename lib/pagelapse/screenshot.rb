require "capybara/dsl"
require "capybara/poltergeist"

module Pagelapse
  # Thanks to http://www.cherpec.com/2013/04/30/capturing-web-page-screenshots-from-ruby/
  # for the basis of this code
  class Screenshot
    include Capybara::DSL

    # Captures a screenshot of +url+ saving it to +output_path+.
    # TODO ADD TIMEOUT
    def capture(url, output_path, width: 1024, height: 768, full: false, timeout: false, allow_errors: false)
      # Browser settings
      page.driver.resize(width, height)
      page.driver.headers = {
        "User-Agent" => "Pagelapse #{Pagelapse::VERSION}",
      }

      # Open page
      visit url

      # Timeout
      sleep timeout if timeout

      if page.driver.status_code == 200
        # Save screenshot
        page.driver.save_screenshot(output_path, :full => full)

        # Resize image
        # ...
      else
        # Handle error
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
      # Additional command line options for PhantomJS
      phantomjs_options: ['--ignore-ssl-errors=yes'],
    })
  end
  Capybara.current_driver = :poltergeist
end
