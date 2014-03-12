require "capybara/dsl"
require "capybara/poltergeist"

module Pagelapse
  # Thanks to http://www.cherpec.com/2013/04/30/capturing-web-page-screenshots-from-ruby/
  # for the basis of this code
  class Screenshot
    include Capybara::DSL

    # Captures a screenshot of +url+ saving it to +output_path+.
    def capture(url, output_path, width: 1024, height: 768, full: false, timeout: false, capture_if: nil, save_if: nil, on_load: nil)

      # Reset session
      Capybara.reset_sessions!

      # Browser settings
      page.driver.resize(width, height)
      page.driver.headers = {
        "User-Agent" => "Pagelapse #{Pagelapse::VERSION}",
      }

      # Set default capture_if and save_if
      unless capture_if
        capture_if = Proc.new do
          page.driver.status_code == 200
        end
      end
      unless save_if
        save_if = Proc.new do |old_file, new_file|
          Digest::MD5.file(old_file).hexdigest != Digest::MD5.file(new_file).hexdigest
        end
      end

      # Open page
      visit url

      # Run on_load
      instance_eval(&on_load) if on_load

      # Timeout
      sleep timeout if timeout

      if instance_eval(&capture_if)
        old_file = last_file_next_to(output_path)

        # Save screenshot
        page.driver.save_screenshot(output_path, :full => full)

        # If no old file, than always save
        return true unless old_file

        if save_if.call(old_file, output_path)
          true
        else
          File.delete output_path
          false
        end
      else
        false
      end
    end

    def start_session(&block)
      self
    end

    private
    def last_file_next_to(file)
      Dir[File.dirname(file) + "/*"].max_by {|f| File.mtime(f)}
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
