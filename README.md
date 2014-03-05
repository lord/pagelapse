# Pagelapse

Generates time-lapses of websites, with ease. Inspirational background music not included.

## Installation

Pagelapse needs phantomjs to take screenshots, so simply run:

    $ brew install phantomjs

And then install pagelapse:

    $ gem install pagelapse

## Usage

Add a page to start capturing:

    $ pagelapse record http://reddit.com

Pagelapse will check the website every 20 seconds for changes. There are some settings, too:

    $ pagelapse record http://reddit.com --interval 60 --width 1200 --height 1000 --full-page false

To view the websites you've recorded in a nice web interface:

    $ pagelapse view

To stop recording a page:

    $ pagelapse stop http://reddit.com

To pause and resume the background server:

    $ pagelapse pause
    $ pagelapse resume

## Contributing

1. Fork it ( <http://github.com/lord/pagelapse/fork> )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
