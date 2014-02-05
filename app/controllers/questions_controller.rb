class QuestionsController < ApplicationController
  def get
  	ep_label = random_episode_label
    @episode = Episode.where(label: ep_label).first
    @pic_link = @episode.random_picture_link
    @answers = [@episode.title] + (Episode.all - [@episode])
      .sample(4)
      .map(&:title)

    logger.debug "el_label: #{ep_label}"
    logger.debug "@episode: #{@episode.inspect}"
    logger.debug "@pic_link: #{@pic_link.inspect}"
    logger.debug "answers: #{@answers.inspect}"
  rescue
    redirect_to action: 'get'
  end

  def post
    logger.debug "PARAMS: #{params}"
    redirect_to action: 'get'
  end

  private

  def random_episode_label
    season = rand(4) + 1
    episode = rand(26) + 1
    episode = rand(13) + 1 if season == 3
    "s#{season}e#{episode.to_s.rjust(2, '0')}"
  end
end
