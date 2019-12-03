def calc_fuel(fuel)
  f = ((fuel/3).floor)-2
  if f <= 0
    0
  else
    f + calc_fuel(f)
  end
end

puts "*********"
puts calc_fuel(1969)
puts "*********"
puts calc_fuel(100756)
puts "*********"

res = 0
File.foreach("1.txt") {|x| res += calc_fuel(x.strip.to_i)}
puts res
