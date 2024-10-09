# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/game_controller'

def main
  puts "Welcome to the Monty Hall paradox game!\nMade by @aleqsanbr [https://github.com/aleqsanbr]\n"
  controller = GameController.new

  loop do
    puts "\nAvailable commands:
          1. Play the game
          2. Automatic game with specified parameters
          3. Run the experiment and show the dependency table of the relative frequency of wins
          4. Exit\n\n"
    print '>>> '
    command = gets.chomp
    case command
    when '1'
      controller.play_game
    when '2'
      controller.automatic_game
    when '3'
      controller.run_experiment
    when '4'
      break
    else
      puts 'Invalid command. Please try again.'
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
