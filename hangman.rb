# frozen_string_literal: true

require 'yaml'

# class SecretWord
class SecretWord
  attr_reader :word
  def initialize
    @word = choose_secret_word
  end

  def choose_secret_word
    dictionary = File.readlines('5desk.txt')
    loop do
      word = dictionary[rand(dictionary.length)].strip.downcase
      return word if word.length >= 5 && word.length <= 12
    end
  end
end

# class Game
class Game
  attr_accessor :secret_word, :guessed_word, :no_of_guesses, :guesses
  def initialize
    @secret_word = SecretWord.new.word
    @guessed_word = '_' * secret_word.length
    @no_of_guesses = 6
    @guesses = String.new
  end

  def play
    until no_of_guesses.zero?
      guess = solicit_guess
      guesses << guess + ' '
      check_guess(guess)
      break if win?
    end
    game_over_message
  end

  def game_menu
    puts '(1) New Game'
    puts '(2) Load Game'
    input = gets.chomp
    load_game if input == '2'
    play
  end

  def solicit_guess
    puts `clear`
    puts 'Welcome to the game of Hangman.'
    puts 'Save game by typing in "save".'
    puts "You have #{no_of_guesses} guesses remaining."
    puts guessed_word
    puts "\nYour guesses so far: #{guesses}"
    loop do
      puts 'Enter your guess(a - z): '
      guess = gets.chomp.downcase
      return guess if valid_guess?(guess)

      save_game if guess.downcase == 'save'

      break
    end
    solicit_guess
  end

  def valid_guess?(guess)
    ('a'..'z').include?(guess) && !guesses.include?(guess)
  end

  def check_guess(guess)
    secret_word.length.times do |i|
      guessed_word[i] = guess if guess == secret_word[i]
    end
    self.no_of_guesses -= 1 unless secret_word.include?(guess)
  end

  def win?
    true if secret_word == guessed_word
  end

  def game_over_message
    puts 'You win!' if win?
    puts "You lose. The correct answer was #{secret_word}" unless win?
  end

  def save_game
    File.open('./test.yml', 'w') { |f| YAML.dump([] << self, f) }
    exit
  end

  def load_game
    yaml = YAML.load_file('./test.yml')
    self.secret_word = yaml[0].secret_word
    self.guessed_word = yaml[0].guessed_word
    self.no_of_guesses = yaml[0].no_of_guesses
    self.guesses = yaml[0].guesses
  end
end

game = Game.new
game.game_menu
