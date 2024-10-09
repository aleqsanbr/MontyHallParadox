# spec/game_spec.rb
require_relative '../lib/game'

RSpec.describe Game do
  (3..20).each do |n|
    context "with #{n} doors" do
      let(:number_of_doors) { n }

      describe '#initialize' do
        let(:game) { Game.new(number_of_doors) }

        it 'creates the correct number of doors' do
          expect(game.doors.size).to eq(number_of_doors)
        end

        it 'randomly assigns a prize to one of the doors' do
          prize_door_index = game.door_with_prize
          expect(game.doors[prize_door_index].has_prize).to be true
        end
      end

      describe '#open_door' do
        let(:game) { Game.new(number_of_doors) }

        it 'marks the selected door as opened' do
          game.open_door(1)
          expect(game.doors[0].is_opened).to be true
        end
      end

      describe '#close_door' do
        let(:game) { Game.new(number_of_doors) }

        it 'marks the selected door as closed' do
          game.close_door(1)
          expect(game.doors[0].is_opened).to be false
        end
      end

      describe '#open_doors_without_prize' do
        let(:game) { Game.new(number_of_doors) }

        it 'opens all doors except the picked door and the door with the prize (in case if the picked door has the prize)' do
          game.pick_door(1)

          game.doors.each_index do |i|
            game.doors[i].has_prize = (i == 0)  # Only the first door has a prize
          end

          game.open_doors_without_prize

          expect(game.doors[0].is_opened).to be false

          opened_doors_count = game.doors[1..].count { |door| door.is_opened }
          expect(opened_doors_count).to eq(number_of_doors - 2)
        end


        it 'opens all doors except the picked door and the door with the prize (in case if the picked door does not have the prize)' do
          game.pick_door(1)

          game.doors.each_index do |i|
            game.doors[i].has_prize = (i == 1)  # Only the second door has a prize
          end

          game.open_doors_without_prize

          expect(game.doors[0].is_opened).to be false

          opened_doors_count = game.doors[1..].count { |door| door.is_opened }
          expect(opened_doors_count).to eq(number_of_doors - 2)
        end
      end

      describe '#pick_door' do
        let(:game) { Game.new(number_of_doors) }

        it 'marks the selected door as picked' do
          game.pick_door(1)
          expect(game.doors[0].is_picked).to be true
        end

        it 'unmarks other doors as picked' do
          game.pick_door(1)
          game.pick_door(2)
          game.pick_door(3)
          expect(game.doors[0].is_picked).to be false
          expect(game.doors[1].is_picked).to be false
          expect(game.doors[2].is_picked).to be true
        end
      end

      describe '#change_door' do
        let(:game) { Game.new(number_of_doors) }

        it 'changes the picked door to another unopened door' do
          game.pick_door(1)
          game.open_doors_without_prize
          unopened_door_index = game.doors.each_index.find { |i| i != game.picked_door && !game.doors[i].is_opened }
          expect(unopened_door_index).not_to be_nil
          game.change_door
          expect(game.picked_door).to eq(unopened_door_index)
        end
      end


      describe '#check_picked_door' do
        let(:game) { Game.new(number_of_doors) }

        it 'returns a win message if the picked door has a prize' do
          game.doors.each_index { |i| game.doors[i].has_prize = (i == 0) }
          game.pick_door(1)
          game.open_picked_door
          expect(game.check_picked_door).to include("You won the car!!!")

          game.doors.each_index { |i| game.doors[i].has_prize = (i == 1) }
          game.pick_door(2)
          game.open_picked_door
          expect(game.check_picked_door).to include("You won the car!!!")
        end

        it 'returns a try again message if the picked door does not have a prize' do
          game.doors.each_index { |i| game.doors[i].has_prize = (i == 0) }
          game.pick_door(2)
          game.open_picked_door
          expect(game.check_picked_door).to include("Try again next time")

          game.doors.each_index { |i| game.doors[i].has_prize = (i == 1) }
          game.pick_door(3)
          game.open_picked_door
          expect(game.check_picked_door).to include("Try again next time")
        end
      end

      describe '#open_picked_door' do
        let(:game) { Game.new(number_of_doors) }

        it 'opens the picked door' do
          game.pick_door(1)
          game.open_picked_door
          expect(game.doors[0].is_opened).to be true
        end
      end
    end
  end
end
