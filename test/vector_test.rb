# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestVector < Minitest::Test
  attr_accessor :u

  def setup
    self.u = V[50, 50]
  end

  def test_basic_projections
    assert_equal 50, u.x
    assert_equal 50, u.y
  end

  def test_turn
    u.turn +90
    assert_in_delta 135, u.angle
  end

  def test_conversions_readers_at_0
    u = V[10, 0]
    assert_equal [10, 0], u.to_a
    assert_equal 10, u.magnitude
    assert_equal  0, u.angle
  end

  def test_conversions_readers_4Q
    u = V[-25, 25]
    assert_in_delta 35.355, u.magnitude, 0.001, "magnitude"
    assert_in_delta 135, u.angle, 0.001, "angle"
  end

  def test_adding_vectors
    q = V[ 0, 10]

    assert_equal V[50, 60], u+q
  end

  def test_add_annulling_vectors
    u = V.new_polar a=0,   m=10
    q = V.new_polar a=180, m=10

    r = u + q
    assert_in_delta 0, r.magnitude, 0.001, "m"
  end

  def test_add_reinforcing_vectors
    u = V.new_polar a=170, m=6
    q = V.new_polar a=170, m=4

    r = u + q
    assert_in_delta 10, r.magnitude, 0.001, "m"
  end

  def test_distance_to
    q = V[0, 0]

    q.x, q.y = 60, 50
    assert_in_epsilon 10, u.distance_to(q)

    q.x, q.y = 50, 40
    assert_in_epsilon 10, u.distance_to(q)

    q.x, q.y = 60, 60
    assert_in_epsilon(10*Math.sqrt(2), u.distance_to(q))

    q.x, q.y = 0, 0
    assert_in_epsilon(50*Math.sqrt(2), u.distance_to(q))
  end

  def test_parallel_projection
    v = V[100, 0]
    assert_equal V[50, 0], v.coll_projection(u)
  end

  def test_perpendicular_projection
    v = V[100, 0]
    assert_equal V[0, 50], v.perp_projection(u)
  end

end

