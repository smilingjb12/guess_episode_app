# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'mechanize'
a = Mechanize.new
a.get('http://mlp.wikia.com/wiki/Episodes')
episode_names = a.page
  .search('table.table-dotted-rows tr td[style^="padding"]')
  .map(&:text)
  .map { |name| name.gsub(/\n/, '') }
  .reject(&:empty?)
episode_names.each do |name|
  episode = Episode.new(title: name)
  episode.save!
end