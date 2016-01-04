require '../lib/graphics.rb'

class Ball < Graphics::Body
  RADIO = 4

  attr_accessor :c, :gravity, :neg_gravity

  def initialize sim_env, grav = false
    super sim_env
    if grav
      self.gravity = mod.gravity
      self.neg_gravity = gravity.reverse
    end
  end

  ##
  # Aggregated vector of forces that affect the body
  # from interacting with all walls

  def resultant
    h = {}
    seg1 = self.to_seg
    i = mod.lines.each do |l|
      h[i] = l if i = seg1.intersection_point_with(l)
    end

    unless h.empty?
      i = h.keys.min { |i| position.distance_to i }
      self.mod.z = i

      return h[i].reaction_to(self)
    end

    nil
  end

  def update
    if r = resultant
      self.apply r
      self.apply neg_gravity if gravity
      # logg
    else
      self.apply mod.gravity if gravity
      move
    end
  end

  def logg
    p m
    p a
    p position
    puts "-"*20
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, RADIO, o.c, :fill
    end
  end
end

class Movie < Graphics::Simulation
  def initialize
    super 800, 800

    self.mod.gravity = Graphics::V.new a: -90, m: 0.3

    add_walls

    self.mod.lines << Wall.new(XY[200, 500], XY[600, 500])
    self.mod.lines << Wall.new(XY[200, 500], XY[400, 700])
    self.mod.lines << Wall.new(XY[600, 500], XY[400, 700])

    self.mod.lines << Wall.new(XY[150, 700], XY[200, 700])
    self.mod.lines << Wall.new(XY[200, 700], XY[200, 650])
    self.mod.lines << Wall.new(XY[150, 600], XY[100, 600])
    self.mod.lines << Wall.new(XY[100, 600], XY[100, 650])

    self.mod.z = nil

    b0 = Ball.new self.mod, true
    b0.x, b0.y = 400, 400
    b0.c = :red
    b0.m = 0
    b0.a = 0

    b1 = Ball.new(self.mod)
    b1.x, b1.y = 100, 200
    b1.c = :blue
    b1.m = 15
    b1.a = 40

    b2 = Ball.new(self.mod)
    b2.x, b2.y = 400, 600
    b2.c = :green
    b2.m = 5
    b2.a = 130

    b3 = Ball.new(self.mod)
    b3.x, b3.y = 100, 500
    b3.c = :yellow
    b3.m = 2
    b3.a = 0

    b4 = Ball.new(self.mod)
    b4.x, b4.y = 150, 650
    b4.c = :red
    b4.m = 3
    b4.a = 45

    register_bodies [b0, b1, b2, b3, b4]
  end

  def draw n
    clear

    canvas.circle 400, 400, 8, :green
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
