require 'open-uri'
require 'json'

class LongestwordController < ApplicationController
  def game
    @grid = generate_grid(10)
  end

  def score
    @word = params[:word]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now
    @grid_result = params[:grid].split("")
    @result = run_game(@word, @grid_result, @start_time, @end_time)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    random_grid = []
    (1..grid_size).each do
      random_grid << ("A".."Z").to_a.sample
    end
    return random_grid
  end

  def check_dico(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_checked = open(url).read
    return JSON.parse(word_checked)
  end

  def check_word(word, grid)
    h_word = {}
    h_grid = {}
    word.downcase.chars.each do |letter|
      h_word.key?(letter) ? h_word[letter] += 1 : h_word[letter] = 1
    end
    grid.join.downcase.chars.each do |letter|
      h_grid.key?(letter) ? h_grid[letter] += 1 : h_grid[letter] = 1
    end
    i = 0
    h_word.each do |letter, value|
      h_grid.key?(letter) && value <= h_grid[letter] ? i : i += 1
    end
    return i.zero?
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    time = end_time - start_time
    if check_word(attempt, grid) == false
      message = "not in the grid"
      score = 0
    elsif check_dico(attempt)["found"] == false
      message = "not an english word"
      score = 0
    else
      message = "well done"
      score = 10 + (check_dico(attempt)["length"] * 10) - (time.to_i / 2)
    end
    return { time: time, message: message, score: score }
  end

end
