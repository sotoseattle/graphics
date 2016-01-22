# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestWalls < Minitest::Test
  attr_accessor :w

  FakeBody = Struct.new :position, :velocity

  def setup
    self.w = Wall.new V[10,10], V[20,20]
  end

  def test_wall_points
    assert_equal V[10, 10], w.point1
    assert_equal V[20, 20], w.point2
  end

  def test_unit_vector
    u = w.uni
    assert_in_delta 1.0, u.magnitude
    assert_in_delta 45, u.angle
  end

  def test_clip
    b = FakeBody.new V[10, 20], V[20, -20]

    reaction = w.clip b

    assert_in_delta b.velocity.magnitude, reaction.magnitude
    assert_in_delta b.velocity.angle, 180 + reaction.angle
  end

  def test_bounce_one_side
    b = FakeBody.new V[10, 20], V[20, -20]

    reaction = w.bounce b

    assert_in_delta 2*b.velocity.magnitude, reaction.magnitude
    assert_in_delta b.velocity.angle, 180 + reaction.angle
  end

  def test_bounce_other_side
    b = FakeBody.new V[20, 10], V[-20, 20]

    reaction = w.bounce b

    assert_in_delta 2*b.velocity.magnitude, reaction.magnitude
    assert_in_delta b.velocity.angle, reaction.angle - 180
  end

end
