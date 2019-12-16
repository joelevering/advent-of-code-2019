class AsteroidMap
  attr_accessor :max_x, :max_y

  def initialize()
    @asteroids = []
  end

  def add_asteroid(x, y)
    @asteroids << [x, y]
  end
end

def map_asteroids(filename)
  asteroids = AsteroidMap.new()

  y = 1
  File.foreach(filename) do |line|
    line = line.strip.split("")
    asteroids.max_x = line.length
    line.each_with_index do |c, x|
      if c == "#"
        asteroids.add_asteroid(x, y)
      end
    end

    y += 1
  end
  asteroids.max_y = y-1

  asteroids
end

puts map_asteroids("10-test.txt").inspect
