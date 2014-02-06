class GamesController < ApplicationController
  before_action :redirect_to_game_if_playing, only: [:start, :index]

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
    answer_label = params[:choice]
    answers = session[:answers]
    if answer_label == session[:correct_episode_label]
      answers << true
    else
      answers << false
    end
    session.delete(:correct_episode_label)
    logger.debug 'ANSWERS_SIZE : ' + answers.size.to_s
    logger.debug 'QUESTION_COUNT: ' + Episode::QUESTION_COUNT.to_s
    if answers.size == Episode::QUESTION_COUNT
      redirect_to action: 'result' 
    else
      redirect_to action: 'next_question'
    end
  end

  def result
    answers = session[:answers]
    unless answers
      redirect_to root_path
      return
    end
    if answers.size < Episode::QUESTION_COUNT
      redirect_to action: 'next_question'
    else # finished playing
      @correct_answers = session[:answers].count(true)
      session.delete(:answers)
    end
  end

  private

  def redirect_to_game_if_playing
    if session[:answers]
      redirect_to action: 'next_question'
    end
  end

  def random_episode_label
    season = rand(4) + 1
    episode = rand(26) + 1
    episode = rand(13) + 1 if season == 3
    "s#{season}e#{episode.to_s.rjust(2, '0')}"
  end
end
