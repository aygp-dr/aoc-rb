module AocUtils
  def self.read_input(year, day)
    day_str = day.to_s.rjust(2, '0')
    File.read("#{year}/day#{day_str}/input.txt")
  end
  
  def self.manhattan_distance(p1, p2)
    p1.zip(p2).sum { |a, b| (a - b).abs }
  end
  
  def self.gcd(a, b)
    b.zero? ? a : gcd(b, a % b)
  end
  
  def self.lcm(a, b)
    (a * b) / gcd(a, b)
  end
  
  # Memoization decorator
  def self.memoize(method_name)
    original = instance_method(method_name)
    cache = {}
    
    define_method(method_name) do |*args|
      cache[args] ||= original.bind(self).call(*args)
    end
  end
end
