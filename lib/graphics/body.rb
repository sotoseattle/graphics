# -*- coding: utf-8 -*-

# require "graphics/v"
# require "graphics/extensions"
require_relative "./v"
require_relative "./extensions"

##
# A body in the simulation.
#
# A body is a fat vector (position, direction and magnitude), that knows
# its daddy (the simulation where it exists) plus some hot moves.

class Graphics::Body < Graphics::V

  ##
  # The cardinal directions.

  NORTH = 90
  SOUTH = -90
  EAST  = 0
  WEST  = 180

  ##
  # Simulation's model in which the Body exists.

  attr_accessor :mod

  ##
  # Create a new body in windowing system +mod+ with a new vector.

  def initialize mod
    self.mod = mod
    super x:rand(mod.w), y:rand(mod.h)
  end

  ##
  # Update the body's state (usually its vector). To be overriden.

  # def update
  # end

  def tick
  end

  def tock
  end

  ##
  # Hop along the vector, so the endpoint becomes the new position.

  def move
    self.position = endpoint
  end

  ##
  # Wrap the body if it hits an edge.

  def wrap
    max_h, max_w = mod.h, mod.w

    self.x = max_w if x < 0
    self.y = max_h if y < 0

    self.x = 0 if x > max_w
    self.y = 0 if y > max_h
  end
end
