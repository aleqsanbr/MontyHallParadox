# frozen_string_literal: true

require_relative 'door'
require_relative 'input_helper'

class Game
  include InputHelper

  attr_accessor :door_with_prize, :doors

  def initialize(number_of_doors = 3)
    @doors = []
    number_of_doors.times { @doors << Door.new }
    random_door = @doors.sample
    random_door.has_prize = true
    @door_with_prize = @doors.index(random_door)
  end

  def to_s
    result = ''
    @doors.each_with_index do |door, index|
      result += "Door #{index + 1}: #{door}\n"
    end
    "#{result}\n"
  end

  # Opens the door.
  # @param door_number [Integer] the number of the door to open (starting from 1)
  def open_door(door_number)
    @doors[door_number - 1].is_opened = true
  end

  # Closes the door.
  # @param door_number [Integer] the number of the door to close (starting from 1)
  def close_door(door_number)
    @doors[door_number - 1].is_opened = false
  end

  # Opens all the doors except the selected one and with a prize. If a door with a prize is selected, then it closes a random door.
  def open_doors_without_prize
    @doors.each_index do |i|
      open_door(i + 1) if i != @picked_door && i != @door_with_prize
    end
    return unless @picked_door == @door_with_prize

    unpicked_doors = @doors.each_index.reject { |i| i == @picked_door }
    close_door(unpicked_doors.sample + 1) unless unpicked_doors.empty?
  end

  # Used after the doors are opened without a prize.
  # There are 2 doors left unopened, and the selected door will be changed to the other one.
  def change_door
    unpicked_doors = @doors.each_index.select { |i| i != @picked_door && !@doors[i].is_opened }
    pick_door(unpicked_doors.sample + 1) unless unpicked_doors.empty?
  end

  # Marks the selected door as picked and the rest as not picked
  # @param door_number [Integer] the number of the selected door (starting from 1)
  def pick_door(door_number)
    @doors.each_index do |i|
      @doors[i].is_picked = i == door_number - 1
    end
    @picked_door = door_number - 1
  end

  def picked_door
    @picked_door
  end

  # Returns the index of the door
  # @param door [Door] the door to find
  # @return [Integer] the index of the door. If the door is not found, returns -1
  def index_of(door)
    @doors.index(door).nil? ? -1 : @doors.index(door)
  end

  # Opens the picked door
  def open_picked_door
    open_door(@picked_door + 1)
  end

  # Opens all the doors
  def open_all_doors
    @doors.each_index do |i|
      open_door(i + 1)
    end
  end

  # @return [Boolean] whether the picked door is opened
  def picked_door_opened?
    @doors[@picked_door].is_opened
  end

  # @return [Boolean] whether the picked door has a prize
  def picked_door_has_prize?
    @doors[@picked_door].has_prize
  end

  # Used in the end of the game. Checks if the picked door has a prize.
  # If the door is opened, it returns the result of the game.
  def check_picked_door
    if @doors[@picked_door].is_opened
      return "You won the car!!!\n\n" if @doors[@picked_door].has_prize

      "Try again next time\n\n"
    else
      "Denied\n"
    end
  end

  # Interactive game
  def play
    puts self
    puts "Hello! Let's play the game!"
    index_to_pick = get_positive_integer("Choose the door (from 1 to #{@doors.length}): ", 1, @doors.length)
    pick_door index_to_pick
    puts self
    puts "Are you sure? Let me help you...\nPress Enter to continue"
    gets
    open_doors_without_prize
    puts self
    answer = get_yes_no('Do you want to change the door? (y/n): ')
    if answer == 'y'
      puts 'Changing the door...'
      change_door
      puts self
    else
      puts 'Well, you are a brave one!'
    end
    puts "Let's see what's behind the picked door... Press Enter to continue"
    gets
    open_all_doors
    puts self
    puts check_picked_door
  end

  # Plays the game a specified number of times and returns the relative frequency of wins.
  # @param number_of_games [Integer] the number of games to play
  # @param number_of_doors [Integer] the number of doors in the game
  # @param change_door [Boolean] whether to change the door in the game
  # @param show_progress [Boolean] whether to show the progress of the game
  # @return [Float] the relative frequency of wins
  def experiment(number_of_games, number_of_doors, change_door, show_progress = false)
    wins = 0
    number_of_games.times do |i|
      game = Game.new(number_of_doors)
      # pick the door randomly
      picked_door = rand(1..number_of_doors).to_i
      game.pick_door(picked_door)
      if show_progress
        puts "\rPlaying game #{i + 1} of #{number_of_games}...\n"
        puts game
      end
      game.open_doors_without_prize
      game.change_door if change_door
      game.open_all_doors
      wins += 1 if game.picked_door_has_prize?
      if show_progress
        puts game
        puts game.check_picked_door
      end
    end
    wins.to_f / number_of_games # relative frequency of wins
  end

  # Prints the table with the relative frequency of wins depending on the number of doors and the strategy.
  # @param number_of_games [Integer] the number of games to play for each number of doors
  # @param num_doors_lower_bound [Integer] the lower bound of the number of doors in experiment
  # @param num_doors_upper_bound [Integer] the upper bound of the number of doors in experiment
  def dependency_table(number_of_games = 10_000, num_doors_lower_bound = 3, num_doors_upper_bound = 10)
    puts 'Relative frequency of wins depending on the number of doors and the strategy'
    puts "Number of experiments for each number of doors: #{number_of_games}"
    puts 'Doors | With changing | Without changing'
    puts '----------------------------------------'
    (num_doors_lower_bound..num_doors_upper_bound).each do |num_doors|
      freq_with_change = experiment(number_of_games, num_doors, change_door).round(6)
      freq_without_change = experiment(number_of_games, num_doors, !change_door).round(6)
      puts "#{num_doors.to_s.ljust(5)} | #{freq_with_change.to_s.ljust(13)} | #{freq_without_change}"
    end
  end
end
