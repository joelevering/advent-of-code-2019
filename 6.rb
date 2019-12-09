def process_map(filename)
  map = {}
  File.foreach(filename) do |line|
    map_data_point = line.strip.split(")")
    orbiting = map_data_point.first
    orbiter = map_data_point.last

    map[orbiter] = orbiting
  end

  map
end

def orbit_count(orbits)
  count = 0
  orbits.values.each do |object_orbited|
    count += count_for_obj(orbits, object_orbited)
  end
  count
end

def count_for_obj(orbits, obj)
  count = 1
  if obj != "COM"
    count += count_for_obj(orbits, orbits[obj])
  end
  count
end

def count_transfers_to(orbits, from, to)
  from_to_com = path_to_com(orbits, orbits[from])
  to_to_com = path_to_com(orbits, orbits[to])
  puts from_to_com.inspect()
  puts to_to_com.inspect()
  uniq_jumps_from = (to_to_com - from_to_com).length
  uniq_jumps_to = (from_to_com - to_to_com).length
  uniq_jumps_from + uniq_jumps_to
end

def path_to_com(orbits, from)
  if orbits[from] == "COM"
    return [from]
  end

  path = path_to_com(orbits, orbits[from])
  path << from
  path
end

#orbits = process_map("6-test.txt")
# puts orbits
# puts orbit_count(orbits)

orbits = process_map("6.txt")
#puts orbit_count(orbits)

#orbits = process_map("6-2-test.txt")

puts count_transfers_to(orbits, "YOU", "SAN")
