#!/usr/local/bin/ruby -w

require 'pry'
# require "graphics"
require_relative "../lib/graphics"
# require './lib/graphics/dynamic.rb'
require './lib/graphics/verlety.rb'

class Ball < Graphics::Body
  include Verlety

  COUNT = 100

  def initialize model
    super
    self.velocity = V[rand(9), rand(9)]
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
    super 800, 800, 16, "Bounce"

    self.model.gravity = V[0, -0.3]

    add_walls

    register_bodies populate Ball
  end

  def draw n
    super
    canvas.fps n, model.start_time
  end
end

BounceSimulation.new.run
