# frozen_string_literal: true

module InputHelper
  # Requires the user to enter a positive integer. If the input is not a valid number, the user will be prompted to enter a valid number.
  # @param prompt [String] the message to display to the user
  # @param min_value [Integer] the minimum value that the number can have
  # @param max_value [Integer] the maximum value that the number can have
  # @return [Integer] the positive integer entered by the user
  def get_positive_integer(prompt, min_value = 1, max_value = nil)
    loop do
      print prompt
      input = gets.chomp
      number = input.to_i
      if number >= min_value && (max_value.nil? || number <= max_value)
        return number
      else
        puts "Please enter a valid number between #{min_value} and #{max_value || 'infinity'}."
      end
    end
  end

  # Requires the user to enter 'y' or 'n'. If the input is not 'y' or 'n', the user will be prompted to enter a valid input.
  # @param prompt [String] the message to display to the user
  # @return [String] 'y' or 'n' entered by the user
  def get_yes_no(prompt)
    loop do
      print prompt
      input = gets.chomp.downcase
      if input != 'y' && input != 'n'
        puts "Please enter 'y' or 'n'."
      else
        return input
      end
    end
  end
end

