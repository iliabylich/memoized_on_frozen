# frozen_string_literal: true

require 'memoized_on_frozen/version'
require 'weakref'

# A builder module that allows you to do memoization on
# frozen objects
#
# @example
#   class YourClass
#     include MemoizedOnFrozen[:m]
#
#     def initialize
#       freeze
#     end
#
#     def m
#       some_heavy_computation
#     end
#   end
#
module MemoizedOnFrozen
  # :nodoc:
  class WeakStore < Hash
    (Hash.instance_methods(false) - [:select!]).each do |method_name|
      define_method(method_name) do |*args, &blk|
        cleanup if potentially_stale?
        super(*args, &blk)
      end
    end

    def initialize(*)
      super
      @last_tracked_gc_run = GC.count
    end

    def cleanup
      select! { |key, _| key.weakref_alive? }
      @last_tracked_gc_run = GC.count
    end

    def potentially_stale?
      @last_tracked_gc_run != GC.count
    end
  end

  WEAK_STORE = WeakStore.new

  # :nodoc:
  module SetWeakRef
    def initialize(*args, &block)
      @_ref = WeakRef.new(self)
      WEAK_STORE[@_ref] = {}
      super(*args, &block)
    end
  end

  class << self
    def _module_for(method_names)
      Module.new do
        method_names.each do |method_name|
          define_method(method_name) do
            WEAK_STORE[@_ref][method_name] ||= super()
          end
        end
      end
    end

    def [](*method_names)
      Module.new do
        define_singleton_method(:included) do |base|
          base.prepend(SetWeakRef, MemoizedOnFrozen._module_for(method_names))
        end
      end
    end
  end
end
