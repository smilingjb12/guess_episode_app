class Episode < ActiveRecord::Base
  QUESTION_COUNT = 10 # how many questions in game

  validates :title, presence: true
  validates :label, presence: true

  def title_url
    CGI::escape(title).gsub(/[+]/, '_')
  end

  def random_picture_link
    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::HTML(open("http://www.google.by/search?q=site%3Amlp.wikia.com%2Fwiki%2F+#{label}+640"))
    href = doc
      .css('h3.r > a')
      .map { |node| node.attributes['href'].value }
      .sample
    href = CGI::unescape(href)
    href = href[href.index('=') + 1 ... href.index('&')]

    doc = Nokogiri::HTML(open(href))
    image_url = doc.at('#file > a > img')
      .attributes['src']
      .value
    image_url
  end 
end
