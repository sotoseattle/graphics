require '/Users/fjs6/work/graphics_code/graphics/lib/graphics.rb'
# require 'geometry'

class Ball < Graphics::Body

  RADIO = 4
  GG = false

  attr_accessor :c, :neg_gravity

  def initialize sim_env
    super
    self.c = :white
  end

  def resultant
    h = {}
    seg1 = self.to_seg
    i = env.lines.each do |l|
      if i = seg1.intersection_point_with(l)
        h[i] = l
      end
    end

    unless h.empty?
      i = h.keys.min { |i| position.distance_to i }
      self.env.z = i

      return h[i].reaction_to(self)
    end

    nil
  end

  def update
    self.neg_gravity ||= env.gravity.reverse

    if r = resultant
      self.apply r
      self.apply neg_gravity if GG
      logg
    else
      self.apply env.gravity if GG
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
      w.line 0, 400, 400-RADIO, 400, :green
      w.line 400+RADIO, 400, w.w, 400, :green
      w.circle o.x, o.y, RADIO, o.c, :fill
      o.env.lines.each { |l| w.line *l.point1, *l.point2, :red }
      if o.env.z
        w.circle o.env.z.x, o.env.z.y, 10, :yellow
        o.env.z = nil
      end
      w.fps o.env.n, o.env.start_time
    end
  end
end

class Movie < Graphics::Simulation
  def initialize
    super 800, 800

    env._bodies.flatten.each &:sync
    self.env.gravity = Graphics::V.new a:-90, m: 0.3

    add_walls
    self.env.lines << Wall.new(XY[200, 500], XY[600, 500])
    self.env.lines << Wall.new(XY[200, 500], XY[400, 700])
    self.env.lines << Wall.new(XY[600, 500], XY[400, 700])

    self.env.z = nil

    b1 = Ball.new(self.env)
    b1.x, b1.y = 100, 200
    b1.c = :red
    b1.m = 15
    b1.a = 40
    b2 = Ball.new(self.env)
    b2.x, b2.y = 400, 600
    b2.c = :green
    b2.m = 5
    b2.a = 130

    register_bodies [b1, b2]
    # register_bodies [b1]
  end
end

Movie.new.run
