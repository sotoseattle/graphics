#!/usr/local/bin/ruby -w

# require "graphics"
require_relative "../../lib/graphics"
require_relative '../../lib/graphics/verlety.rb'

class Ballsy < Graphics::Body
  include Verlety

  attr_accessor :lefty, :right, :spoke, :c

  MAX = 1.5
  MIN = 0.5
  COUNT = 10
  K = 10

  def initialize m
    self.spoke = []
    super
    # self.acceleration = model.gravity
    self.c = :white
  end

  def interact
    return if self.position == V[model.w/2, model.h/2]

    r = V[0,0]
    r += self.spoke.reduce(r) { |t, s| t += compute(s, model.spk) }
    r += compute(lefty, model.sep) if lefty
    r += compute(right, model.sep) if right

    self.acceleration = r

    super
  end

  def compute other, eq_dist
    v = other.position - self.position
    signo = ((v.magnitude - eq_dist) > 0 ? +1 : -1)
    push = (v.magnitude - eq_dist)**2 / K

    distance_to_other = v.magnitude
    if push > distance_to_other
      push = 0
    end

    # seg = position - spoke.first               # Force spoke move
    # seg.coll_projection(v.unit * signo * push) # only !!

    v.unit * signo * push
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, 1, o.c, :filled
      if o.lefty
        d = o.position.distance_to(o.lefty.position)
        c = (d <= o.model.sep * MIN || d >= o.model.sep * MAX) ? :red : :blue
        w.line(o.x, o.y, o.lefty.x, o.lefty.y, c) if o.lefty
      end
      if o.spoke.size == 1
        # w.line(o.x, o.y, o.spoke.first.x, o.spoke.first.y, :yellow)
      end
    end
  end
end

class Nonesense < Graphics::Simulation
  RADIO = 150
  STEP = 10

  attr_accessor :b0, :b1, :b2

  def initialize
    super 700, 700, 16, "Chain"

    # self.model.gravity = V[0, -0.1]

    add_walls

    model.spk = RADIO
    model.sep = V[RADIO, 0].distance_to(V.new_polar(STEP, RADIO))

    balls = (0...360).step(STEP).map do |angle|
      b = Ballsy.new model
      b.position = V[model.w/2, model.h/2] + V.new_polar(angle, RADIO+rand(10)-5)
      # b.position = V[model.w/2, model.h/2] + V.new_polar(angle, RADIO)
      b.prevpos = b.position
      b
    end

    origin = Ballsy.new model
    origin.position = V[model.w/2, model.h/2]
    origin.prevpos = origin.position

    # bz = balls.sample
    # bz.position = V[bz.x + 0.1, bz.y]


    balls.each_with_index do |b, i|
      b.lefty = balls[i-1]
      b.right = balls[i+1]
    end
    balls.last.right = balls.first
    balls.first.lefty = balls.last

    balls.each do |b|
      b.spoke << origin
      origin.spoke << b
    end

    balls << origin

    register_bodies balls

  end

  def circle_3_points p1, p2, p3
    temp = p2.x*p2.x+p2.y*p2.y
    bc = (p1.x*p1.x + p1.y*p1.y - temp)/2.0
    cd = (temp - p3.x*p3.x - p3.y*p3.y)/2.0

    det = (p1.x-p2.x)*(p2.y-p3.y)-(p2.x-p3.x)*(p1.y-p2.y)
    return nil if det.abs < 1.0e-6

    xw = (bc*(p2.y-p3.y)-cd*(p1.y-p2.y))/det;
    yw = ((p1.x-p2.x)*cd-(p2.x-p3.x)*bc)/det;

    V[xw, yw]
  end

  def draw n
    super
    # c = circle_3_points b0, b1, b2
    # r = c.distance_to b0

    # canvas.circle c.x, c.y, r, :green
    # sleep 0.01
    canvas.fps n, model.start_time
  end
end

Nonesense.new.run

