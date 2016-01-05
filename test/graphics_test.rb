# -*- coding: utf-8 -*-

require "minitest/autorun"

$: << File.expand_path("~/Work/p4/zss/src/minitest-focus/dev/lib")
require "minitest/focus"

# require "graphics"
require_relative "../lib/graphics"

class TestInteger < Minitest::Test
  def test_match
    srand 42
    assert_equal [0, 1], 2.times.map { rand(2) }

    srand 42
    assert(1 =~ 2)
    refute(1 =~ 2)
  end
end

class TestNumeric < Minitest::Test
  def test_close_to
    assert_operator 1.0001, :close_to?, 1.0002
    refute_operator 1.0001, :close_to?, 2.0002
  end

  def test_degrees
    assert_equal 1, 361.degrees
    assert_equal 359, -1.degrees
  end

  def test_relative_angle
    assert_equal 10, 0.relative_angle(10, 20)
    assert_equal  5, 0.relative_angle(10,  5)

    assert_equal 180, 180.relative_angle(0, 360)
    assert_equal 185, 0.relative_angle(185, 360) # huh?

    assert_equal(-180, 0.relative_angle(270, 180)) # Huh?
  end
end

class TestSimulation < Minitest::Test
  # make_my_diffs_pretty!

  class FakeSimulation < Graphics::Simulation
    def initialize
      super 100, 100, 16, "blah"

      add_walls

      s = []

      def s.method_missing *a
        @data ||= []
        @data << a
      end

      def s.data
        @data
      end

      self.canvas = s
    end
  end

  attr_accessor :t, :white, :exp

  def setup
    self.t = FakeSimulation.new
    # self.white = t.canvas.color[:white]
    self.white = Canvas.new(0, 0, 0, '', 0).color[:white]
    self.exp = []
  end

  def test_angle
    skip
    h = t.env.h-1

    t.canvas.angle 50, 50, 0, 10, :white
    exp << [:draw_line, 50, h-50, 60.0, h-50.0, white]

    t.canvas.angle 50, 50, 90, 10, :white
    exp << [:draw_line, 50, 49, 50.0, h-60.0, white]

    t.canvas.angle 50, 50, 180, 10, :white
    exp << [:draw_line, 50, h-50, 40.0, h-50.0, white]

    t.canvas.angle 50, 50, 270, 10, :white
    exp << [:draw_line, 50, h-50, 50.0, h-40.0, white]

    t.canvas.angle 50, 50, 45, 10, :white
    d45 = 10 * Math.sqrt(2) / 2
    exp << [:draw_line, 50, h-50, 50+d45, h-50-d45, white]

    assert_equal exp, t.canvas.data
  end

  # def test_bezier
  #   raise NotImplementedError, 'Need to write test_bezier'
  # end
  #
  # def test_blit
  #   raise NotImplementedError, 'Need to write test_blit'
  # end
  #
  # def test_circle
  #   raise NotImplementedError, 'Need to write test_circle'
  # end
  #
  # def test_clear
  #   raise NotImplementedError, 'Need to write test_clear'
  # end
  #
  # def test_debug
  #   raise NotImplementedError, 'Need to write test_debug'
  # end
  #
  # def test_draw
  #   raise NotImplementedError, 'Need to write test_draw'
  # end
  #
  # def test_draw_and_flip
  #   raise NotImplementedError, 'Need to write test_draw_and_flip'
  # end

  def test_ellipse
    skip
    t.canvas.ellipse 0, 0, 25, 25, :white

    h = t.env.h-1
    exp << [:draw_ellipse, 0, h, 25, 25, t.canvas.color[:white]]

    assert_equal exp, t.canvas.data
  end

  # def test_fast_rect
  #   raise NotImplementedError, 'Need to write test_fast_rect'
  # end
  #
  # def test_fps
  #   raise NotImplementedError, 'Need to write test_fps'
  # end
  #
  # def test_handle_event
  #   raise NotImplementedError, 'Need to write test_handle_event'
  # end
  #
  # def test_handle_keys
  #   raise NotImplementedError, 'Need to write test_handle_keys'
  # end

  def test_hline
    skip
    t.canvas.hline 42, :white
    h = t.env.h - 1
    exp << [:draw_line, 0, h-42, 100, h-42, t.canvas.color[:white]]

    assert_equal exp, t.canvas.data
  end

  # def test_image
  #   raise NotImplementedError, 'Need to write test_image'
  # end

  def test_line
    skip
    t.line 0, 0, 25, 25, :white
    h = t.h - 1
    exp << [:draw_line, 0, h, 25, h-25, t.color[:white]]

    assert_equal exp, t.canvas.data
  end

  def test_point
    skip "not yet"
    t.point 2, 10, :white

    exp = [nil, nil, t.color[:white]]
    assert_equal exp, t.canvas

    skip "This test isn't sufficient"
  end

  # def test_populate
  #   raise NotImplementedError, 'Need to write test_populate'
  # end
  #
  # def test_rect
  #   raise NotImplementedError, 'Need to write test_rect'
  # end
  #
  # def test_register_color
  #   raise NotImplementedError, 'Need to write test_register_color'
  # end
  #
  # def test_render_text
  #   raise NotImplementedError, 'Need to write test_render_text'
  # end
  #
  # def test_run
  #   raise NotImplementedError, 'Need to write test_run'
  # end
  #
  # def test_sprite
  #   raise NotImplementedError, 'Need to write test_sprite'
  # end
  #
  # def test_text
  #   raise NotImplementedError, 'Need to write test_text'
  # end
  #
  # def test_text_size
  #   raise NotImplementedError, 'Need to write test_text_size'
  # end
  #
  # def test_update
  #   raise NotImplementedError, 'Need to write test_update'
  # end
  #
  # def test_vline
  #   raise NotImplementedError, 'Need to write test_vline'
  # end
end

# require 'graphics/rainbows'
# class TestGraphics < Minitest::Test
#   def setup
#     @t = Graphics::Simulation.new 100, 100, 16, ""
#   end
#
#   def test_registering_rainbows
#     spectrum = Graphics::Hue.new
#     @t.initialize_rainbow spectrum, "spectrum"
#     assert_equal @t.color[:red], @t.color[:spectrum_0]
#     assert_equal @t.color[:green], @t.color[:spectrum_120]
#     assert_equal @t.color[:blue], @t.color[:spectrum_240]
#   end
# end

# class TestTrail < Minitest::Test
#   def test_draw
#     raise NotImplementedError, 'Need to write test_draw'
#   end
#
#   def test_lt2
#     raise NotImplementedError, 'Need to write test_lt2'
#   end
# end
