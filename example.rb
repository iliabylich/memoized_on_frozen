# bundle exec ruby example.rb

require 'memoized_on_frozen'

class Rectangle
  include MemoizedOnFrozen[:area]

  def initialize(x, y)
    @x = x
    @y = y

    freeze
  end

  def area
    puts 'calculating area'
    @x * @y
  end
end

rectangle1 = Rectangle.new(1, 2)
rectangle2 = Rectangle.new(3, 4)

puts rectangle1.area
puts rectangle1.area

puts rectangle2.area
puts rectangle2.area

p MemoizedOnFrozen::WEAK_STORE.keys
# => [rectangle1, rectangle2]

rectangle1 = rectangle2 = nil
GC.start
p MemoizedOnFrozen::WEAK_STORE.keys
# => []
