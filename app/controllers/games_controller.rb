require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @lettersarr = []
    (1..10).each { @lettersarr << ("A".."Z").to_a.sample }
    @letters = @lettersarr.flatten
  end

  def score
    @word = params[:word]
    @letters = params[:grid].split(" ")
    @found = lewagon_api_request(@word)
    valid = check_word_letters(@word, @letters)[:bool]
    if !valid
      @message = "Sorry but <strong>#{@word.upcase}</strong> can't be build out of #{@letters.join(", ")}"
    elsif valid && @found["found"] == false
      @message = "Sorry but <strong>#{@word.upcase}</strong> does not seem to be a valid English word..."
    else
      @message = "<strong>Congratulations!</strong> #{@word.upcase} is a valid English word!"
    end
  end

  def check_word_letters(word, grid)
    valid = { bool: true }
    word.upcase.split("").each do |l|
      if grid.index(l)
        grid.delete_at(grid.index(l))
      else
        valid[:bool] = false
        valid[:letter] = l
        break
      end
    end
    return valid
  end

  def lewagon_api_request(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    response_json = open(url).read
    return JSON.parse(response_json)
  end
end

