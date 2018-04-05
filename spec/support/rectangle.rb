# frozen_string_literal: true

class Rectangle
  include Memoized[:area]

  def initialize(x, y)
    @x = x
    @y = y

    freeze
  end

  def area
    ScratchPad << [@x, @y]
    @x * @y
  end
end
