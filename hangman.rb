# frozen_string_literal: true

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

  def solicit_guess
    puts `clear`
    puts 'Welcome to the game of Hangman.'
    puts "You have #{no_of_guesses} guesses remaining."
    puts guessed_word
    puts
    puts "Your guesses so far: #{guesses}"
    loop do
      puts 'Enter your guess(a - z): '
      guess = gets.chomp.downcase
      return guess if ('a'..'z').include?(guess) && !guesses.include?(guess)

      break
    end
    solicit_guess
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
end

game = Game.new
game.play
