# frozen_string_literal: true

# Represents a door in the Monty Hall game.
#
# @!attribute [r/w] is_opened
#   Indicates whether the door is opened or closed.
# @!attribute [r/w] has_prize
#   Indicates whether the door has the prize behind it.
# @!attribute [r/w] is_picked
#   Indicates whether the door has been selected by the player.
class Door
  attr_accessor :is_opened, :has_prize, :is_picked

  def initialize(is_opened: false, has_prize: false, is_picked: false)
    @is_opened = is_opened
    @has_prize = has_prize
    @is_picked = is_picked
  end

  def to_s
    result = ''
    result += @is_picked ? "\t>>> " : "\t    "
    result + if @is_opened
               @has_prize ? '🚗 The car!!!' : '🐐 A goat'
             else
               '🚪'
             end
  end
end
