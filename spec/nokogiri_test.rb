require 'nokogiri'

class NokoTest
  webpage = <<~END_PAGE
    <html>
      <body>
        <p>Marvin the Martian, from Warner Bros, was <a href="https://kidadl.com/quotes/marvin-the-martian-quotes-from-the-looney-tunes-beloved-character">often angry</a>.</p>
        <p>Being disintegrated makes me very angry! Very angry indeed!</p>
        <p>I’m not angry. Just terribly, terribly hurt.</p>
        <p>You make me very angry, very angry.</p>
        <p>Flux to blow Mars into subatomic space dust make me very angry.</p>
      </body>
    </html>
  END_PAGE

  html = Nokogiri.HTML(webpage)
  html.css('p').each do |node|
    # This strips any HTML tags from node.content:
    node.content = node.content.gsub('angry', 'happy')
  end
  puts "\n\nHTML:\n#{html}"
end
