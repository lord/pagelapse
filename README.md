# Pagelapse

Generates time-lapses of websites, with ease. Inspirational background music not included.

## Installation

Pagelapse needs phantomjs to take screenshots, so simply run:

    $ brew install phantomjs

And then install pagelapse:

    $ gem install pagelapse

## Usage

To create a new pagelapse, add a `Lapsefile` to the current directory. If your timelapse is associated with a project, you may want to add this to the root directory of your project.

In the `Lapsefile`, you can specify (using Ruby) which pages you'd like to record. For instance, to record a screenshot of my blog, `lord.io`, every 10 seconds with a browser window 1000 pixels by 800 pixels:

```ruby
record "lord", "http://www.lord.io/blog" do |r|
  r.width = 1000
  r.height = 800
  r.interval = 10
end
```

You can also run Capybara commands before the screenshot is taken:

```ruby
record "github", "http://github.com/login" do |r|
  r.interval = 10
  r.before_capture do
    page.fill_in('login', :with => 'lord')
    page.fill_in('password', :with => 'my password here')
    page.click_button('Sign in')
  end
end
```

There are a couple other settings. The default behavior is capture pages only if they return a HTTP 200. You can change this by setting a `capture_if`, for instance if you only want to record if the page contains certain elements, or based on the status code:

```ruby
record "lord", "http://www.lord.io/blog" do |r|
  r.capture_if do
    page.driver.status_code == 404
  end
end
```

For instance, the above code will only capture the page *if* a 404 error code was generated.

By default, new screenshots will be deleted if they are exactly the same as the previous screenshot. You can override this with `save_if`:

```ruby
record "lord", "http://www.lord.io/blog" do |r|
  r.save_if do |old_file, new_file|
    # Add checking code here
    true
  end
end
```

For example, the code above will always save new screenshots. You could potentially use the `old_file` and `new_file` parameters passed (as file names) to the `save_if` block with Imagemagick or some other image program to determine if the images are different enough to save. The default method is to check the cryptographic hashes of the two files are the same.

To view the websites you've recorded in a nice web interface:

    $ pagelapse view

Drag your cursor from left to right to play the timelapse.

## Contributing

1. Fork it ( <http://github.com/lord/pagelapse/fork> )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
