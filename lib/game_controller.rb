# frozen_string_literal: true

require_relative 'input_helper'

class GameController
  include InputHelper

  def play_game
    number_of_doors = get_positive_integer('Enter the number of doors (at least 3): ', 3)
    return unless number_of_doors

    game = Game.new(number_of_doors)
    game.play

    puts "Press Enter to continue..."
    gets
  end

  def automatic_game
    number_of_games = get_positive_integer('Enter the number of games (greater than 0): ', 1)
    return unless number_of_games

    number_of_doors = get_positive_integer('Enter the number of doors (at least 3): ', 3)
    return unless number_of_doors

    # picked_door = get_positive_integer("Enter the number of the picked door (1 to #{number_of_doors}): ", 1, number_of_doors)
    # return unless picked_door

    change_door = get_yes_no('Change the door? (y/n): ') == 'y' ? true : false
    show_progress = get_yes_no('Show the progress of the game? (y/n): ') == 'y' ? true : false

    game = Game.new(number_of_doors)
    puts "The relative frequency of wins: #{game.experiment(number_of_games, number_of_doors, change_door, show_progress)}"
  end

  def run_experiment
    number_of_games = get_positive_integer('Enter the number of games: ', 1)
    return unless number_of_games

    num_doors_lower_bound = get_positive_integer('Enter the lower bound of the number of doors: ', 3)
    return unless num_doors_lower_bound

    num_doors_upper_bound = get_positive_integer('Enter the upper bound of the number of doors: ', num_doors_lower_bound)
    return unless num_doors_upper_bound

    game = Game.new(3)
    game.dependency_table(number_of_games, num_doors_lower_bound, num_doors_upper_bound)
  end
end