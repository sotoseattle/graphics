require './lib/graphics.rb'
require './lib/graphics/segment.rb'
require './lib/graphics/dynamic.rb'

class Ball < Graphics::Body
  include Dynamic

  RADIO = 4

  attr_accessor :c

  def initialize sim_env, grav = false
    super sim_env

    self.acceleration = model.gravity if grav
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

    self.model.gravity = V.new_polar a= -90, m= 0.3

    add_walls

    self.model.lines << Wall.new(V[200, 500], V[600, 500])
    self.model.lines << Wall.new(V[200, 500], V[400, 700])
    self.model.lines << Wall.new(V[600, 500], V[400, 700])

    self.model.lines << Wall.new(V[150, 700], V[200, 700])
    self.model.lines << Wall.new(V[200, 700], V[200, 650])
    self.model.lines << Wall.new(V[150, 600], V[100, 600])
    self.model.lines << Wall.new(V[100, 600], V[100, 650])

    self.model.z = nil

    b0 = Ball.new self.model, true
    b0.x, b0.y = 400, 400
    b0.c = :red

    b1 = Ball.new self.model
    b1.x, b1.y = 100, 200
    b1.c = :blue
    b1.velocity = V.new_polar a = 40, m = 10

    b2 = Ball.new self.model
    b2.x, b2.y = 400, 600
    b2.c = :green
    b2.velocity = V.new_polar a = 130, m = 5

    b3 = Ball.new self.model
    b3.x, b3.y = 100, 500
    b3.c = :yellow
    b3.velocity = V.new_polar a = 0, m = 2

    b4 = Ball.new self.model
    b4.x, b4.y = 150, 650
    b4.c = :red
    b4.velocity = V.new_polar a = 44.5, m = 3

    register_bodies [b0, b1, b2, b3, b4]
  end

  def draw n
    clear

    canvas.circle 400, 400, 8, :green
    model.lines.each { |l| canvas.line *l.point1, *l.point2, :red }
    canvas.fps n, model.start_time

    if model.z
      canvas.circle model.z.x, model.z.y, 10, :yellow
      model.z = nil
    end

    self.model._bodies.each do |ary|
      draw_collection ary
    end
  end
end

Movie.new.run
