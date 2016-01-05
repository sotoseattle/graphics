# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestBody < Minitest::Test
  attr_accessor :w, :b

  def assert_body x, y, m, a
    assert_in_delta x,  b.x,  0.001, "x"
    assert_in_delta y,  b.y,  0.001, "y"
    assert_in_delta a,  b.a,  0.001, "a"
    assert_in_delta m,  b.m,  0.001, "m"
  end

  def setup
    self.w = Graphics::Simulation.new(100, 100)
    self.b = Graphics::Body.new w.mod

    b.x = 50
    b.y = 50
    b.m = 10
    b.a = 0
  end

  def test_movement
    assert_body  50, 50, 10, 0

    b.move
    assert_body  60, 50, 10, 0
  end

  def test_wrapping
    b.x = 99

    assert_body  99, 50, 10, 0

    b.move
    b.wrap

    assert_body   0, 50, 10, 0
  end

end

