class Episode < ActiveRecord::Base
  validates :title, presence: true
  validates :label, presence: true

  def title_url
    CGI::escape(title).gsub(/[+]/, '_')
  end

  def random_picture_link
    require 'mechanize'
    a = Mechanize.new
    a.get("http://www.google.by/search?q=site%3Amlp.wikia.com%2Fwiki%2F+#{label}")
    href = a.page
      .search('h3.r > a')
      .map { |node| node.attributes['href'].value }
      .sample

    a.get(href)
    image_url = a.page.at('#file > a > img')
      .attributes['src']
      .value
    image_url
  end 
end
