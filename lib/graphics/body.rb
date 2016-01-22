# -*- coding: utf-8 -*-

require 'forwardable'
# require "graphics/v"
# require "graphics/extensions"
require_relative "./v"
require_relative "./extensions"
require_relative "./segment"

##
# A body in the simulation.

class Graphics::Body
  extend Forwardable

  attr_accessor :model, :position

  def_delegators :position, :x, :x=, :y, :y=

  ##
  # Create a new body in windowing system +model+.

  def initialize model
    self.model = model
    self.position = V.new rand(1..model.w-1), rand(1..model.h-1)
  end

  ##
  # Update (1st step) by computing interactions. Override.

  def interact
  end

  ##
  # Update (2nd step) the body's state. Override.

  def update
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
