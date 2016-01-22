#!/usr/local/bin/ruby -w

# require "graphics"
require_relative "../lib/graphics"
require './lib/graphics/dynamic.rb'

class Ball < Graphics::Body
  include Dynamic

  COUNT = 50

  def initialize model
    super
    self.velocity = V[rand(9), 8-rand(9)]
    self.acceleration = model.gravity
  end

  class View
    def self.draw w, o
      w.angle o.x, o.y, o.velocity.angle, 10+3*o.velocity.magnitude, :red
      w.circle o.x, o.y, 5, :white, :filled
    end
  end

end

class BounceSimulation < Graphics::Simulation

  def initialize
    super 640, 640, 16, "Bounce"

    self.model.gravity = V[0, -0.3]

    add_walls

    register_bodies populate Ball
  end

  def initialize_keys
    super
    add_keydown_handler " ", &:randomize
    add_keydown_handler "r", &:reverse
  end

  def randomize
    self.model._bodies.each { |b| b.velocity = V[9 - rand(9), rand(9)] }
  end

  def reverse
    self.model.gravity.turn 180
  end

  LOG_INTERVAL = 120

  def log
    # puts self.model._bodies.flatten.map(&:velocity).inject(&:+).magnitude
  end

end

BounceSimulation.new.run
