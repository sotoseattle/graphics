#!/usr/local/bin/ruby -w

# require "graphics"
require_relative "../../lib/graphics"
require_relative '../../lib/graphics/dynamic.rb'

class Particle < Graphics::Body
  include Dynamic

  attr_accessor :lefty, :right, :spoke, :c

  COUNT = 10

  def initialize m
    self.spoke = []
    super
    self.c = :white
    # self.acceleration = model.gravity
  end

  def compute other, eq_dist
    v = other.position - self.position
    v.unit * (v.magnitude - eq_dist)**3 / K**2
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, 1, o.c, :filled
    end
  end
end

class Nonesense < Graphics::Simulation
  RADIO = 100
  STEP = 10

  attr_accessor :b0, :b1, :b2

  def initialize
    super 700, 700, 16, "Chain"

    add_walls

    # self.model.gravity = V.new_polar(-90, 0.01)

    b0 = Particle.new model
    b0.position = V[model.w/2, model.h/2]
    b0.velocity = V[1,1]
    b0.c = :green

    b1 = Particle.new model
    b1.position = V[model.w/2 + 100, model.h/2 + 100]

    register_bodies [b0, b1]

  end

  def draw n
    super
    canvas.fps n, model.start_time
  end
end

Nonesense.new.run

