#!/usr/local/bin/ruby -w

# require "graphics"
require_relative "../../lib/graphics"
require_relative '../../lib/graphics/dynamic.rb'

class Particle < Graphics::Body
  include Dynamic

  attr_accessor :lefty, :right, :spoke, :c

  COUNT = 10

  def initialize m, pos
    self.spoke = []
    super m
    self.position = pos
    self.c = :white
    # self.acceleration = model.gravity
  end

  def compute other, eq_dist
    v = other.position - self.position
    v.unit * (v.magnitude - eq_dist)**3 / K**2
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, 2, o.c, :filled
    end
  end
end

class Bar
  attr_accessor :parts

  def initialize p1, p2
    self.parts = [p1, p2]
  end

  def vel= v
    parts.each { |p| p.velocity = v }
  end

  def interact
    parts.each(&:interact)
  end

  def update
    parts.each(&:update)
  end

  class View
    def self.draw w, o
      cls = o.parts.first.class.const_get :View
      o.parts.each do |obj|
        cls.draw w, obj
      end

      w.line o.parts.first.x, o.parts.first.y, o.parts.last.x, o.parts.last.y, :yellow
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

    b0 = Particle.new model, V[model.w/2, model.h/2]
    b1 = Particle.new model, V[model.w/2 + 50, model.h/2 + 20]

    duo = Bar.new b0, b1
    duo.vel = V[1, 0]

    register_bodies [duo]

  end

  def draw n
    super
    canvas.fps n, model.start_time
  end
end

Nonesense.new.run

