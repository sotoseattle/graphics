# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestWalls < Minitest::Test
  attr_accessor :w, :b

  def assert_body x, y, m, a
    assert_in_delta x,  b.x,  0.001, "x"
    assert_in_delta y,  b.y,  0.001, "y"
    assert_in_delta a,  b.a,  0.001, "a"
    assert_in_delta m,  b.m,  0.001, "m"
  end

  def setup
    self.w = Graphics::Simulation.new(100, 100)
    self.w.add_walls
    self.b = Graphics::Body.new w.mod
    self.b.extend LinearMotion

    b.x = 50
    b.y = 50
    b.m = 10
    b.a = 0
  end

  def test_bounce_east_wall
    b.x = 99

    assert_body 99, 50, 10,   0
    b.tick
    b.tock
    assert_body 99, 50, 10, 180
  end

  def test_bounce_NE_corner_equidistant
    b.x = b.y = 99
    b.a = 45

    assert_body 99, 99, 10, 45
    b.tick
    b.tock
    assert_body 99, 99, 10, -45
  end

  def test_bounce_NE_corner_offset
    b.x = 99
    b.y = 96
    b.a = 45

    assert_body 99, 96, 10, 45
    b.tick; b.tock
    assert_body 99, 96, 10, 135
    b.tick; b.tock
    assert_body 99, 96, 10, -135
  end

  def test_move_bounced
    b.x = 99
    b.m = 10000

    assert_body  99,  50, 10000,  0
    b.tick; b.tock
    assert b.x < 100
  end

end

class TestObstacles < Minitest::Test
  attr_accessor :w, :b

  def assert_body x, y, m, a
    assert_in_delta x,  b.x,  0.001, "x"
    assert_in_delta y,  b.y,  0.001, "y"
    assert_in_delta a,  b.a,  0.001, "a"
    assert_in_delta m,  b.m,  0.001, "m"
  end

  def setup
    self.w = Graphics::Simulation.new(100, 100)
    self.w.mod.lines << Wall.new(XY[50, 0], XY[100, 100])
    self.b = Graphics::Body.new w.mod
    self.b.extend LinearMotion
  end

  def test_bounce_against_obstacle
    b.x = 50
    b.y = 50
    b.a = 0
    b.m = 30

    b.tick; b.tock
    assert_body 50, 50, 30, 126.87

    b.tick; b.tock
    assert_body 32, 74, 30, 126.87
  end

  def test_bounce_on_other_side
    b.x = 90
    b.y = 50
    b.a = 180
    b.m = 30

    b.tick; b.tock
    assert_body 90, 50, 30, -53.13

    b.tick; b.tock
    assert_body 108, 26, 30, -53.13
  end

  def test_no_bounce_edgewise
    self.w.mod.lines << Wall.new(XY[0, 50], XY[10, 50])

    b.x = 15
    b.y = 50
    b.a = 180
    b.m = 10

    b.tick; b.tock
    assert_body 5, 50, 10, 180

    b.tick; b.tock
    assert_body -5, 50, 10, 180
  end

end

class TestGravField < Minitest::Test
  attr_accessor :w, :b

  def setup
    self.w = Graphics::Simulation.new(100, 100)
    self.w.mod.lines << Wall.new(XY[0, 0], XY[100, 0])
    self.b = Graphics::Body.new w.mod
    self.b.extend LinearMotion

    self.w.mod.pos_gravity = Graphics::V.new a: -90, m: 0.3
    self.w.mod.neg_gravity = Graphics::V.new a: +90, m: 0.3

    self.b.define_singleton_method(:tock) do
      if r
        self.apply r
        self.apply mod.neg_gravity
      else
        self.apply mod.pos_gravity
        move
      end
      self.r = nil
    end
  end

  def test_bounce_back_to_original_height
    b.x = b.y = 50
    b.a = b.m = 0

    top_height = 0
    10_000.times do
      b.tick; b.tock
      top_height = b.y if b.y > top_height
    end

    assert_equal 50, top_height
  end

end

