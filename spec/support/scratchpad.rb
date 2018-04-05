# frozen_string_literal: true

module ScratchPad
  module_function

  def recorded
    @recorded ||= []
  end

  def <<(value)
    recorded << value
  end

  def clear
    @recorded = []
  end
end
