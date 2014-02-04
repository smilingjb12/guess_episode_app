class QuestionsController < ApplicationController
  def get
  	episodes = Episode.all
  	@episode = episodes.sample
  	@pic_link = @episode.random_picture_link
  	@answers = episodes.sample(3).map(&:title) + [@episode.title]
  end
end
