# require "graphics"

require_relative "../lib/graphics"
require './lib/graphics/dynamic.rb'

# A way to compute pi as the ratio of the area of a polygon and the
# diameter of the enclosing circle. A set of bouncing bullets create
# new vertices as they hit the perimeter of the circle. As the number
# of vertices tends to infinite the polygon will converge to the
# circle and the ratio to pi.

srand 42

class Polygnome < Array
  attr_reader :origin, :model

  def initialize origin, model
    @model = model
    @origin = origin
  end

  class View
    def self.draw w, o
      if o.size > 2
        points = o << o.first
        points.each_cons(2) do |a, b|
          w.line a.x, a.y, b.x, b.y, :yellow
        end
      end
    end
  end

  def add vertex
    self << vertex

    if size > 2
      sort_radar
      SDL::WM.set_caption compute_pi, ''
    end
  end

  ##
  # Sort vertex like a radar, by angle to center.

  def sort_radar
    sort_by! do |v|
      (360 + Math.atan2((v.y - origin.y), (v.x - origin.x))) % 360
    end
  end

  ##
  # Algorithm to compute area of polygon, needs vertex sorted
  # in radar mode.

  def compute_area
    sol = 0.0
    j = size - 1
    each_with_index do |v, i|
      sol += (self[j].x + v.x) * (self[j].y - v.y)
      j = i
    end
    (sol / 2.0).abs
  end

  def compute_pi
    "Pi: " + "%1.5f" % [compute_area / model.r**2]
  end
end

class Bouncer < Graphics::Body
  include Dynamic

  COUNT = 10
  M = 10

  def initialize mod
    super mod

    self.position = V[rand(model.w/4) + model.r, rand(model.h/4) + model.r]
    self.velocity = V.new_polar rand(360), M
  end

  def outside_circle? p
    (p.x - model.r)**2 + (p.y - model.r)**2 > model.r**2
  end

  ##
  # Slope and offset of line given 2 points.

  def line_to p
    slope  = (p.y - y) / (p.x - x)
    offset = y - (slope * x)
    [slope, offset]
  end

  ##
  # Intersection of enclosing circle and line y = ax + b.
  # Algebraic solution.

  def intersection_circle_and l
    a, b = l
    beta = Math.sqrt((2 * a * model.r**2) - (2 * a * b * model.r) - b**2 + (2 * b * model.r))
    alfa = model.r - (a * (b - model.r))
    gama = (1 + a**2)

    x0 = [(alfa + beta)/gama, (alfa - beta)/gama].min_by {|e| (e - x).abs}
    y0 = a*x0 + b
    V[x0, y0]
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, 2, :white, :filled
    end
  end

  def interact
    e = endpoint
    if outside_circle? e
      self.position = intersection_circle_and line_to(e)

      alpha = velocity.cart_to_polar[:a] + (160 + rand(15) - 15)
      self.velocity = V.polar_to_cart(alpha, velocity.magnitude)

      model.poly.add position
    end
  end
end

class PiPolygon < Graphics::Simulation
  RADIO = 400

  def initialize
    super RADIO * 2, RADIO * 2

    self.model.r = RADIO
    self.model.poly = Polygnome.new V[model.r, model.r], self.model

    register_bodies populate Bouncer
  end

  def draw n
    clear

    canvas.circle model.r, model.r, model.r, :green

    draw_collection [model.poly]

    self.model._bodies.each { |ary| draw_collection ary }
  end

end

PiPolygon.new.run if $0 == __FILE__
