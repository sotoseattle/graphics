# -*- coding: utf-8 -*-

require 'forwardable'
# require "graphics/v"
# require "graphics/extensions"
require_relative "./v"
require_relative "./extensions"
require_relative "./segment"

##
# A body in the simulation.
#
# A body is a fat vector (position, direction and magnitude), that knows
# its daddy (the simulation where it exists) plus some hot moves.

class Graphics::Body
  extend Forwardable

  attr_accessor :model, :position, :velocity, :acceleration

  def_delegators :position, :x, :x=, :y, :y=

  ##
  # Create a new body in windowing system +model+.

  def initialize model
    self.model = model
    self.position = V.new rand(1..model.w-1), rand(1..model.h-1)
    self.velocity = V.new 0.0, 0.0
    self.acceleration = V.new 0.0, 0.0
  end

  ##
  # Update the body's state (usually its vector) in two stages. Override.

  def tick
    self.velocity += self.acceleration

    while r = resultant
      r += model.gravity if model.gravity
      self.velocity += r
    end
  end

  def tock
    move
  end

  ##
  # Position after a time unit elapses.

  def endpoint
    self.position + self.velocity
  end

  ##
  # Move and hop so the endpoint becomes the new position.

  def move
    self.position = endpoint
  end

  ##
  # Wrap the body if it hits an edge.

  def wrap
    max_h, max_w = model.h, model.w

    self.x = max_w if x < 0
    self.y = max_h if y < 0

    self.x = 0 if x > max_w
    self.y = 0 if y > max_h
  end

end
