require 'test/unit'

class TestRoman < Test::Unit::TestCase  
  def setup
    @a = Roman.new(5)
    @b = Roman.new("IV")
    @c = Roman.new("III")
  end
  
  def test_1creation
    assert(@a.to_i == 5, 'Creation test failed (arabic)')
    assert(@b.to_i == 4, 'Creation test failed (roman IV)')
    assert(@c.to_i == 3, 'Creation test failed (roman III)')
    assert(Roman.new("MMXII").to_i == 2012, 'Creation test failed (roman MMXII)')
    assert(Roman.new("XXMMV").to_i == 1985, 'Creation test failed (roman XXMMV)')
    assert(Roman.new("XMXMV").to_i == 1985, 'Creation test failed (roman XMXMV)')
    assert(Roman.new("MXXMV").to_i == 1985, 'Creation test failed (roman MXXMV)')
    assert(Roman.new("MDCLXVI").to_i == 1666, 'Creation test failed (roman MDCLXVI)')
  end

  def test_2arithmetic
    @a.add(@b)
    assert(@a.to_i == 9, 'Addition test failed')
    @a.subtract(@c)
    assert(@a.to_i == 6, 'Subtraction test failed')
  end
  
  def test_3tos2toi
    assert(Roman.new(Roman.new(1666).to_s).to_i == 1666, 'to_s failed 1666')
    assert(Roman.new(Roman.new(6743).to_s).to_i == 6743, 'to_s failed 6743')
    assert(Roman.new(Roman.new(3687).to_s).to_i == 3687, 'to_s failed 3687')
  end
end

class Roman
  VALUES = {
    "M" => 1000,
    "D" => 500,
    "C" => 100,
    "L" => 50,
    "X" => 10,
    "V" => 5,
    "I" => 1,
    }
  
  def initialize(number = 0)
    case number
    when Integer
      @number = number
    else
      @number = parse_roman(number)
    end    
  end
  
  def parse_roman(s)
    char_block = ""
    number = 0    
      
    return 0 if /[^IVXLCDM]/.match(s)
    
    s.each_char do |char|
      if !char_block.empty? && char_block[0].chr != char then 
        if VALUES[char_block[0]] > VALUES[char] then
          number += char_block.length * VALUES[char_block[0]]
        else
          number -= char_block.length * VALUES[char_block[0]]
        end

        char_block = ""
      end
      
      char_block += char
    end

    return number += char_block.length * VALUES[char_block[0]]
  end

  def add(roman)
    @number += roman.to_i
  end
  
  def subtract(roman)
    @number -= roman.to_i
  end
  
  def to_i
    return @number
  end
  
  # Generierte keine Zahlen wie IV sondern IIII -> trotzdem valide römische zahl
  def to_s
    return "NaRL" if @number <= 0
    num = @number
    s = ""
    
    values = VALUES.invert
    
    values.each do |v, l|
      while num >= v do
        s += l
        num -= v
      end
    end
    
    return s
  end
end