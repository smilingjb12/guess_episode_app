class Episode < ActiveRecord::Base
  validates :title, presence: true

  def title_url
    CGI::escape(title).gsub(/[+]/, '_')
  end

  def random_picture_link
    require 'mechanize'
    a = Mechanize.new
    a.get("http://mlp.wikia.com/#{title_url}/Gallery")
    links = a.page
      .search('.thumb .gallery-image-wrapper a.image')
      .map { |e| e.attributes['href'].value }
    random_link = links.sample
    a.get("http://mlp.wikia.com#{random_link}")
    a.page.at('#file a > img')
      .attributes['src']
      .value
  end 
end
