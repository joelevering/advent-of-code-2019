class IntcodeComputer
  PositionMode = "position"
  ImmediateMode = "immediate"

  attr_reader :outputs, :complete, :name

  def initialize(name: "computer", code:)
    @name = name
    @hash = hash_input(code)
    @pointer = 0
  end

  def compute(inputs)
    @outputs = []
    increment_pointer = true

    while true do
      cmd = @hash[@pointer]
      ops_code = get_ops_code(cmd)
      modes = get_modes(cmd)

      case ops_code
      when "99"
        @complete = true
        break
      when "01"
        args = get_args(3)
        #puts get_value(args[0], modes[0]).inspect
        #puts get_value(args[1], modes[1]).inspect
        res = get_value(args[0], modes[0]) + get_value(args[1], modes[1])
        set_value(res, args[2])
      when "02"
        args = get_args(3)
        res = get_value(args[0], modes[0]) * get_value(args[1], modes[1])
        set_value(res, args[2])
      when "03"
        args = get_args(1)
        if inputs.length > 0
          @hash[args[0]] = inputs.shift
        else
          increment_pointer = false
          break
        end
      when "04"
        args = get_args(1)
        @outputs << get_value(args[0], modes[0])
      when "05"
        args = get_args(2)
        if get_value(args[0], modes[0]) != 0
          @pointer = get_value(args[1], modes[1])
          increment_pointer = false
        end
      when "06"
        args = get_args(2)
        if get_value(args[0], modes[0]) == 0
          @pointer = get_value(args[1], modes[1])
          increment_pointer = false
        end
      when "07"
        args = get_args(3)
        if get_value(args[0], modes[0]) < get_value(args[1], modes[1])
          set_value(1, args[2])
        else
          set_value(0, args[2])
        end
      when "08"
        args = get_args(3)

        if get_value(args[0], modes[0]) == get_value(args[1], modes[1])
          set_value(1, args[2])
        else
          set_value(0, args[2])
        end
      end

      if increment_pointer
        @pointer += instructions_for_ops_code(ops_code)
      else
        increment_pointer = true
      end
    end
  end

  def get_args(num_args)
    args = []
    for i in 1..num_args do
      args << @hash[@pointer+i]
    end
    args
  end

  def get_value(param, mode)
    if mode == PositionMode
      @hash[param]
    elsif mode == ImmediateMode
      param
    end
  end

  def set_value(val, param)
    @hash[param] = val
  end

  def hash_input(input)
    h = {}
    input.split(",").each_with_index do |n, i|
      h[i] = n.to_i
    end

    return h
  end

  def get_ops_code(cmd)
    format("%02d", cmd)[-2..-1]
  end

  def get_modes(cmd)
    map = format("%05d", cmd)[0..2].reverse.split("").map do |c|
      if c == "0"
        PositionMode
      elsif c == "1"
        ImmediateMode
      end
    end
  end

  def instructions_for_ops_code(ops_code)
    case ops_code
    when "01", "02", "07", "08"
      4
    when "03", "04"
      2
    when "05", "06"
      3
    end
  end
end

def test_amplifiers(code, phases)
  max = 0
  combo = nil

  phases.permutation.each do |arr|
    res = amplify_loop(code, arr[0], arr[1], arr[2], arr[3], arr[4])
    if res > max
      max = res
      combo = arr
    end
  end

  puts max
  puts combo.inspect
end

def amplify_loop(code, a, b, c, d, e)
  amp_a = IntcodeComputer.new(name: "A", code: code)
  amp_b = IntcodeComputer.new(name: "B", code: code)
  amp_c = IntcodeComputer.new(name: "C", code: code)
  amp_d = IntcodeComputer.new(name: "D", code: code)
  amp_e = IntcodeComputer.new(name: "E", code: code)

  amps = [amp_a, amp_b, amp_c, amp_d, amp_e]

  amp_a.compute([a, 0])
  amp_b.compute([b] + amp_a.outputs)
  amp_c.compute([c] + amp_b.outputs)
  amp_d.compute([d] + amp_c.outputs)
  amp_e.compute([e] + amp_d.outputs)

  inputs = amp_e.outputs

  i = 0
  while true
    if amps[i].complete == true
      if amps[i].name == "E"
        break
      end
    else
      amps[i].compute(inputs)
      inputs = amps[i].outputs
    end

    if i == 4
      i = 0
    else
      i += 1
    end
  end

  return amp_e.outputs[0]
end

def amplify(code, a, b, c, d, e)
  amp_a = IntcodeComputer.new
  amp_b = IntcodeComputer.new
  amp_c = IntcodeComputer.new
  amp_d = IntcodeComputer.new
  amp_e = IntcodeComputer.new

  amp_a.compute(code, [a, 0])
  amp_b.compute(code, [b, amp_a.output])
  amp_c.compute(code, [c, amp_b.output])
  amp_d.compute(code, [d, amp_c.output])
  amp_e.compute(code, [e, amp_d.output])

  return amp_e.output
end

test = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0"
test3 = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0"
#puts test_amplifiers(test, [4,3,2,1,0])
#puts test_amplifiers(test3, [4,3,2,1,0])

day_seven = "3,8,1001,8,10,8,105,1,0,0,21,38,59,76,89,106,187,268,349,430,99999,3,9,1002,9,3,9,101,2,9,9,1002,9,4,9,4,9,99,3,9,1001,9,5,9,1002,9,5,9,1001,9,2,9,1002,9,3,9,4,9,99,3,9,1001,9,4,9,102,4,9,9,1001,9,3,9,4,9,99,3,9,101,4,9,9,1002,9,5,9,4,9,99,3,9,1002,9,3,9,101,5,9,9,1002,9,3,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99"
#puts test_amplifiers(day_seven, [4,3,2,1,0])

test4 = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
#puts test_amplifiers(test4, [5, 6, 7, 8, 9])
puts test_amplifiers(day_seven, [5, 6, 7, 8, 9])
