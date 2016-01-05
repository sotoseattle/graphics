# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestXY < Minitest::Test
  attr_accessor :p

  def setup
    self.p = XY.new 50, 50
  end

  def test_angle_to
    q = XY[0, 0]

    q.x, q.y = 60, 50
    assert_in_epsilon 0, p.angle_to(q)

    q.x, q.y = 50, 40
    assert_in_epsilon 270, p.angle_to(q)

    q.x, q.y = 60, 60
    assert_in_epsilon 45, p.angle_to(q)

    q.x, q.y = 0, 0
    assert_in_epsilon 225, p.angle_to(q)
  end

  def test_distance_to
    q = XY[0, 0]

    q.x, q.y = 60, 50
    assert_in_epsilon 10, p.distance_to(q)

    q.x, q.y = 50, 40
    assert_in_epsilon 10, p.distance_to(q)

    q.x, q.y = 60, 60
    assert_in_epsilon(10*Math.sqrt(2), p.distance_to(q))

    q.x, q.y = 0, 0
    assert_in_epsilon(50*Math.sqrt(2), p.distance_to(q))
  end
end


