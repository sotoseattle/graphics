require './lib/graphics.rb'
require './lib/graphics/geometria.rb'

class Ball < Graphics::Body
  include LinearMotion

  RADIO = 4

  attr_accessor :c, :otro, :name, :r, :gravity, :neg_gravity

  def initialize sim_env, name, grav = false
    super sim_env
    if grav
      self.gravity = mod.gravity
      self.neg_gravity = gravity.reverse
    end
    self.name = name
  end

  def resultant # STILL NEED TO PASS THIS ONE !!!! AND BALLS TESTS
    h = {}

    # self.otro ||= (mod._bodies.flatten - [self]).first
    # potential_collisions = (mod.lines + [otro]).compact
    self.otro ||= (mod._bodies.flatten - [self])      # test for single ball too
    potential_collisions = (mod.lines + otro).compact

    i = potential_collisions.each do |z|
      h[i] = z if i = z.intersection_point_with(self)
    end

    unless h.empty?
      i = h.keys.min { |i| position.distance_to i }
      self.mod.z = i

      return h[i].reaction_to(self)
    end

    nil
  end

  def tock
    if r
      self.apply(r)
      self.apply neg_gravity if gravity
    else
      self.apply mod.gravity if gravity
      move
    end
    self.r = nil
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, RADIO, o.c, :fill
    end
  end
end

class Movie < Graphics::Simulation
  def initialize
    super 700, 700

    self.mod.gravity = Graphics::V.new a: -90, m: 0.3

    add_walls

    self.mod.z = nil

    b0 = Ball.new self.mod, "red"
    b0.x, b0.y = 350, 400
    b0.c = :red
    b0.m = 0
    b0.a = 0

    b1 = Ball.new self.mod, "yell"
    b1.x, b1.y = 350, 600
    b1.c = :yellow
    b1.m = 3
    b1.a = -90

    b2 = Ball.new self.mod, "green"
    b2.x, b2.y = 350, 200
    b2.c = :green
    b2.m = 3
    b2.a = 90

    register_bodies [b0, b1, b2]
  end

  def draw n
    clear

    canvas.hline 650, :blue
    mod.lines.each { |l| canvas.line *l.point1, *l.point2, :red }
    canvas.fps n, mod.start_time

    if mod.z
      canvas.circle mod.z.x, mod.z.y, 10, :yellow
      mod.z = nil
    end

    self.mod._bodies.each do |ary|
      draw_collection ary
    end
  end
end

Movie.new.run


# to find intersection send to receiver

# make test of 0 vs 90 => 45
#   - assure they dont stay stuck on corner
# make test other angle with different m
# makes test escaping in corner
# make test one body with m, the other at rest (collinear?)
#
# collinear same direction
# collinear oppo direction
# refactor resultant so intersect is inside the class, even if Ball extends Segment
