class GamesController < ApplicationController
  def index
  end

  def start
    session[:answers] = []
    redirect_to action: 'next_question'
  end

  def next_question
  	ep_label = random_episode_label
    @correct_episode = Episode.where(label: ep_label).first
    @pic_link = @correct_episode.random_picture_link
    @episodes = [@correct_episode] + (Episode.all - [@wrong_episodes]).sample(4)
    @episodes.shuffle!
    @current_question = session[:answers].size + 1
    session[:correct_episode_label] = @correct_episode.label # store to check for answer later
  rescue
    redirect_to action: 'next_question'
  end

  def answer
    logger.debug "ANSWERS:::::::::::::: #{session[:answers].inspect}"
    answer_label = params[:choice]
    answers = session[:answers]
    if answer_label == session[:correct_episode_label]
      answers << true
    else
      answers << false
    end
    session.delete(:correct_episode_label)
    if answers.size == Episode::QUESTION_COUNT
      redirect_to action: 'result' 
    else
      redirect_to action: 'next_question'
    end
  end

  def result
    @correct_answers = session[:answers].count(true)
  end

  private

  def random_episode_label
    season = rand(4) + 1
    episode = rand(26) + 1
    episode = rand(13) + 1 if season == 3
    "s#{season}e#{episode.to_s.rjust(2, '0')}"
  end
end
