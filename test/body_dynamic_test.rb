# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"
require_relative "../lib/graphics/dynamic"

class TestBodyDynamic < Minitest::Test
  attr_accessor :b

  def setup
    w = Graphics::Simulation.new(100, 100)
    self.b = Graphics::Body.new w.model
    b.extend Dynamic
    b.position = V.new(50, 50)
    b.velocity = V[10, 0]
  end

  def test_vectors
    assert_in_delta 50, b.x
    assert_in_delta 50, b.y
    assert_equal 10, b.velocity.magnitude
    assert_equal 0, b.velocity.angle
  end

  def test_push_to_the_right
    assert_equal V[50, 50], b.position
    assert_equal V[60, 50], b.endpoint
  end

  def test_push_up
    b.velocity = V[0, 10]
    assert_equal V[50, 50], b.position
    assert_equal V[50, 60], b.endpoint
  end

  def test_push_to_the_left
    b.velocity = V[-10, 0]
    assert_equal V[50, 50], b.position
    assert_equal V[40, 50], b.endpoint
  end

  def test_push_down
    b.velocity = V[0, -10]
    assert_equal V[50, 50], b.position
    assert_equal V[50, 40], b.endpoint
  end

  def test_wrapping
    b.x = 99

    assert_in_delta 99, b.x
    assert_in_delta 50, b.y

    b.move
    b.wrap

    assert_in_delta  0, b.x
    assert_in_delta 50, b.y
  end

end

