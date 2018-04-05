# MemoizedOnFrozen

Immutable objects are a good thing, but they can't use memoization:

``` ruby
class Rectangle
  def initialize(x, y)
    @x = x
    @y = y

    freeze
  end

  def area
    @area ||= @x * @y
  end
end

Rectangle.new(2, 3).area
# => FrozenError (can't modify frozen Rectangle)
```

This gem offers a very simple solution - it performs a memoization on a "global" registry object.

Like this:
``` ruby
def area
  $registry[self][:area] ||= @x * @y
end
```

But then we face another problem: memory leaking. Every object that is memoized creates a garbage
in the "global" variable that is never GC-ed. This can be solved using `WeakRef` Ruby class.

`MemoizedOnFrozen` uses a `Hash` as a registry under the hood, but this hash uses `WeakRef`s as keys.

## Example

Declare a class:
``` ruby
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
```

And see how the library handles it:

``` ruby
rectangle1 = Rectangle.new(1, 2)
rectangle2 = Rectangle.new(3, 4)

rectangle1.area
# calculating area
# => 2
rectangle1.area
# => 2

rectangle2.area
# calculating area
# => 12
rectangle2.area
# => 12

MemoizedOnFrozen::WEAK_STORE.keys
# => [rectangle1, rectangle2]

rectangle1 = rectangle2 = nil
GC.start
MemoizedOnFrozen::WEAK_STORE.keys
# => []
```

You can find a working example in `example.rb`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'memoized_on_frozen'
```

Or if you'd like to use an alias `Memoized` instead of `MemoizedOnFrozen`
(and you are 100% sure that there are no conflicts with existing classes):

``` ruby
gem 'memoized_on_frozen', require: 'memoized_on_frozen/as_memoized'
```

The file `lib/memoized_on_frozen/as_memoized.rb` literally does `Memoized = MemoizedOnFrozen`

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install memoized_on_frozen


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iliabylich/memoized_on_frozen.
