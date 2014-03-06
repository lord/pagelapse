require 'sinatra'

module Pagelapse
  class Viewer < Sinatra::Base
    configure do
      set :public_folder, 'lapses'
    end
    get '/' do
      names = Dir['lapses/*']
      names.map! do |filename|
        filename.match(/^[^\/]+\/(.+)/)[1]
      end
      names.map! do |link|
        "<p><a href='#{link}'>#{link}</a></p>"
      end
      names.join
    end
    get '/:name' do
      files = Dir[File.join('lapses', params[:name], '*')]
      files.map! do |filename|
        filename.match(/^[^\/]+\/(.+)/)[1]
      end
      html = <<-HTML
<html>
<head>
  <style>
  body {
    display: table;
    width: 100%;
    height: 100%;
  }
  #wrapper {
    display: table-cell;
    vertical-align: middle;
    max-width: 100%;
    max-height: 100%;
    text-align: center;
  }
  </style>
  <script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
  <script>
  var imgs = [];
  var urls = [];
  function preloadImages(urls)
  {
    for(i in urls) {
      var img = new Image();
      img.src=urls[i];
      imgs.push(img);
    }
  }
  urls = <%= files.to_json %>;
  preloadImages(urls);
  function setImage(num) {
    document.getElementById('image').src = urls[num];
  }

  $(function () {
    $('body').mousemove(function (e) {
      var pagewidth = $(window).width();
      var mousex = event.pageX;
      var num = Math.floor((mousex / pagewidth) * urls.length);
      setImage(num);
    });
  });
  </script>
</head>
<body>
<div id="wrapper">
<img id="image">
</div>
</body>
</html>
      HTML

    erb html, locals: {files: files}
    end
  end
end