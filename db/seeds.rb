# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)





require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://mlp.wikia.com/wiki/Episodes'))
episode_names = doc
  .css('table.table-dotted-rows tr td[style^="padding"]')
  .map(&:text)
  .map { |name| name.gsub(/\n/, '').strip }
  .reject(&:empty?)
season_number = 1
episode_number = 1
episode_names.each do |name|
  episode = Episode.new(title: name, label: "s#{season_number}e#{episode_number.to_s.rjust(2, '0')}")
  episode.save!
  episode_number += 1
  if episode_number == 27 || season_number == 3 && episode_number == 14
    season_number += 1
    episode_number = 1
  end
end