# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestVector < Minitest::Test
  attr_accessor :u

  def setup
    self.u = Graphics::V.new(x:50, y:50, a:0, m:10)
  end

  def test_conversions_vector
    assert_in_delta 50, u.x, 0.001, "x"
    assert_in_delta 50, u.y, 0.001, "y"
    assert_in_delta  0, u.a, 0.001, "angle"
    assert_in_delta 10, u.m, 0.001, "magnitude"
  end

  def test_projection_on_axis
    def assert_vector_projection x, y, u1
      dxy = u1.dx_dy
      assert_in_delta x, dxy.x, 0.001, "m"
      assert_in_delta y, dxy.y, 0.001, "a"
    end

    assert_vector_projection    10,   0, Graphics::V.new(a:0,      m:10)
    assert_vector_projection    10,   0, Graphics::V.new(a:360,    m:10)
    assert_vector_projection    10,   0, Graphics::V.new(a:24*360, m:10)
    assert_vector_projection     0,  10, Graphics::V.new(a:90, m:10)
    assert_vector_projection     0, -10, Graphics::V.new(a:-90, m:10)
    assert_vector_projection     0, -10, Graphics::V.new(a:270, m:10)
    assert_vector_projection (-10),   0, Graphics::V.new(a:180, m:10)
  end

  def test_reset_vector_by_changing_endpoint
    def assert_reset a, m, xy
      u1 = Graphics::V.new
      u1.endpoint = xy
      assert_in_delta a, u1.a, 0.001, 'a'
      assert_in_delta m, u1.m, 0.001, 'm'
    end

    assert_reset      0, 10, XY[10, 0]
    assert_reset     90, 10, XY[0, 10]
    assert_reset  (-90), 10, XY[0, -10]
    assert_reset    180, 10, XY[-10, 0]
    assert_reset    135, Math.sqrt(200), XY[-10, 10]
    assert_reset (-135), Math.sqrt(200), XY[-10, -10]
  end

  def test_random_angle
    srand 42
    assert_in_delta 134.834, u.random_angle
  end

  def test_random_turn
    srand 42
    assert_in_delta 16, u.random_turn(45)
  end

  def test_turn
    assert_in_delta 0, u.a
    u.turn 90
    assert_in_delta 90, u.a
  end

  def test_conversions_readers
    assert_equal XY[50, 50], u.position
    assert_equal 10, u.m
    assert_equal  0, u.a
  end

  def test_change_position
    u.position = XY[50, 40]
    assert_in_delta 50, u.x
    assert_in_delta 40, u.y
    assert_equal 10, u.m
    assert_equal 0, u.a
  end

  def test_push_to_the_right
    u.a = 0
    u.m = 10
    assert_equal XY[50, 50], u.position
    assert_equal XY[60, 50], u.endpoint
  end

  def test_push_up
    u.a = 90
    u.m = 10
    assert_equal XY[50, 50], u.position
    assert_equal XY[50, 60], u.endpoint
  end

  def test_push_to_the_left
    u.a = 180
    u.m = 10
    assert_equal XY[50, 50], u.position
    assert_equal XY[40, 50], u.endpoint
  end

  def test_push_down
    u.a = 270
    u.m = 10
    assert_equal XY[50, 50], u.position
    assert_equal XY[50, 40], u.endpoint
  end

  def test_setting_endpoint_at_0
    u.endpoint = XY[60, 50]
    assert_in_delta 10, u.m, 0.001, "magnitude"
    assert_in_delta 0, u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_1Q
    u.endpoint = XY[75, 75]
    assert_in_delta 35.355, u.m, 0.001, "magnitude"
    assert_in_delta 45, u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_90
    u.endpoint = XY[50, 60]
    assert_in_delta 10, u.m, 0.001, "magnitude"
    assert_in_delta 90, u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_2Q
    u.endpoint = XY[25, 75]
    assert_in_delta 35.355, u.m, 0.001, "magnitude"
    assert_in_delta 135, u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_180
    u.endpoint = XY[40, 50]
    assert_in_delta 10, u.m, 0.001, "magnitude"
    assert_in_delta 180, u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_3Q
    u.endpoint = XY[25, 25]
    assert_in_delta 35.355, u.m, 0.001, "magnitude"
    assert_in_delta (-135), u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_270
    u.endpoint = XY[50, 40]
    assert_in_delta 10, u.m, 0.001, "magnitude"
    assert_in_delta (-90), u.a, 0.001, "angle"
  end

  def test_setting_endpoint_at_4Q
    u.endpoint = XY[75, 25]
    assert_in_delta 35.355, u.m, 0.001, "magnitude"
    assert_in_delta (-45), u.a, 0.001, "angle"
  end

  def test_adding_vectors
    q = Graphics::V.new a:90, m:10

    r = u + q
    assert_equal 45, r.a
    assert_equal Math.sqrt(200), r.m
  end

  def test_add_annulling_vectors
    q = Graphics::V.new a:180, m:10

    r = u + q
    assert_equal 0, r.a
    assert_in_delta 0, r.m, 0.001, "m"
  end

  def test_add_reinforcing_vectors
    u.a = 30
    q = Graphics::V.new a:30, m:10

    r = u + q
    assert_in_delta 30, r.a, 0.001, "a"
    assert_in_delta 20, r.m, 0.001, "m"
  end

  def test_application
    gravity = Graphics::V.new a:270, m:10
    u.apply gravity
    assert_in_delta -45, u.a, 0.001, "a"
  end

  def test_to_segment
    assert_equal XY[50, 50], u.to_seg.leftmost_endpoint
    assert_equal XY[60, 50], u.to_seg.rightmost_endpoint
  end
end

