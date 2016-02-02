#!/usr/local/bin/ruby -w

# require "graphics"
require_relative "../../lib/graphics"
require_relative '../../lib/graphics/verlety.rb'

class Ballsy < Graphics::Body
  include Verlety

  attr_accessor :lefty, :right, :diago, :c

  COUNT = 10
  K = 2_000

  def initialize m
    super
    self.c = :green
  end

  def interact
    r = V[0,0]
    r += compute(lefty, model.sep)
    r += compute(right, model.sep)
    r += compute_diag(diago)
    self.acceleration = r

    super
  end

  def update
    super 1.99, 0.99
  end

  def compute_diag arr
    return V[0,0] if arr.empty?
    arr.reduce(V[0,0]) { |r, o| r += compute(o, Math.sqrt(2) * model.sep) }
  end

  def compute other, eq_dist
    return V[0,0] unless other

    v = other.position - self.position
    signo = ((v.magnitude - eq_dist) > 0 ? +1 : -1)
    push = (v.magnitude - eq_dist)**2 / K

    v.unit * signo * push
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, 5, o.c, :filled
      spring(o, [*o.diago, o.lefty, o.right], w)
    end

    def self.spring a, lines, w
      lines.each do |l|
        vec = l.position - a.position
        seg = vec.magnitude / 5.0
        vun = vec.unit

        q = a.position
        (0..3).each do |i|
          q = q + (vun * seg)
          w.circle q.x, q.y, 1, :yellow
        end
      end
    end
  end
end

class Nonesense < Graphics::Simulation

  def initialize
    super 700, 700, 16, "Chain"

    add_walls
    k = model.sep = 100

    base = 385
    stretch = 40 # <===== Change here to strecht corners

    b0, b1, b2, b3, c0, c1, d0, d1, e0 = (0..9).map {Ballsy.new model}

    b0.position = V[base, base];    b0.prevpos = b0.position
    b1.position = V[base, base-k]; b1.prevpos = b1.position
    b2.position = V[base-k - stretch, base-k - stretch]; b2.prevpos = b2.position
    b3.position = V[base-k, base]; b3.prevpos = b3.position

    b0.lefty = b1; b0.right = b3; b0.diago = [b2, c1, d1, e0]
    b1.lefty = b2; b1.right = b0; b1.diago = [b3, d0]
    b2.lefty = b3; b2.right = b1; b2.diago = [b0]
    b3.lefty = b0; b3.right = b2; b3.diago = [b1, c0]

    c0.position = V[base, base + k]; c0.prevpos = c0.position
    c1.position = V[base - k, base + k]; c1.prevpos = c1.position
    c0.lefty = c1; c0.right = b0; c0.diago = [b3, d0]
    c1.lefty = b3; c1.right = c0; c1.diago = [b0]

    d0.position = V[base + k, base]; d0.prevpos = d0.position
    d1.position = V[base + k, base - k]; d1.prevpos = d1.position
    d0.lefty = b0; d0.right = d1; d0.diago = [b1, c0]
    d1.lefty = b1; d1.right = d0; d1.diago = [b0]

    e0.position = V[base + k + stretch, base + k + stretch]; e0.prevpos = e0.position
    e0.lefty = d0; e0.right = c0; e0.diago = [b0]

    register_bodies [b0, b1, b2, b3, c0, c1, d0, d1, e0]
  end

  def draw n
    super
    canvas.fps n, model.start_time
  end
end

Nonesense.new.run

# distance_to_other = v.magnitude
# if push > distance_to_other
#   self.acceleration = 0
#   self.velocity = V[0,0]
#   push = 0
# end
