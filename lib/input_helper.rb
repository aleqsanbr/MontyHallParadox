# frozen_string_literal: true

module InputHelper
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

