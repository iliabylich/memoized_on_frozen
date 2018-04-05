# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MemoizedOnFrozen do
  let(:rectangle) { Rectangle.new(2, 5) }

  before do
    GC.start
    ScratchPad.clear
    rectangle.area
  end

  it 'keeps initial methods implementation' do
    expect(rectangle.area).to eq(10)
  end

  it 'memoizes methods' do
    expect(ScratchPad.recorded).to eq([[2, 5]])
  end

  it 'memoizes everything on the Memoized::WEAK_STORE object' do
    expect(Memoized::WEAK_STORE.keys.length).to eq(1)
  end

  it 'has no memory leaks' do
    tmp = Rectangle.new(3, 3)
    tmp.area
    tmp = nil
    expect { GC.start }.to change { Memoized::WEAK_STORE.keys.length }.by(-1)
  end
end
