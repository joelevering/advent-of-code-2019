def password_count(min, max)
  count = 0
  for p in min..max do
    if is_password?(p)
      count += 1
    end
  end
  count
end

def is_password?(p)
  pa = p.to_s.split("")
  has_repeating_digits?(pa) && does_not_decrease?(pa)
end

def has_repeating_digits?(pa)
  res = false
  for i in 1..5 do
    if pa[i] == pa[i-1]
      res = true
    end
  end
  res
end

def does_not_decrease?(pa)
  pa = pa.map {|c| c.to_i}
  pa[0] <= pa[1] && pa[1] <= pa[2] && pa[2] <= pa[3] && pa[3] <= pa[4] && pa[4] <= pa[5]
end

#puts is_password?(111111)
#puts is_password?(223450)
#puts is_password?(123789)

puts is_password?(112233) # true
puts is_password?(123444) # false
puts is_password?(111122) # true

min = 138241
max = 674034
#puts password_count(min, max)
