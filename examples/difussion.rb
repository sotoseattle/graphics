require './lib/graphics.rb'
require './lib/graphics/linear_motion.rb'

class Ball < Graphics::Body
  include LinearMotion

  attr_accessor :c, :r, :f

  RADIO = 5

  def initialize sim_env, grav = false
    super sim_env
    self.f = false
    self.r = RADIO
  end

  def tick
    return if m == 0
    super
  end

  def tock
    return if m == 0

    if mod.polyp.touching? self
      mod.polyp.grow self
    else
      move
    end
  end

  def calcify
    self.m = 0
    self.c = :green
    self.f = true
  end

  class View
    def self.draw w, o
      w.circle o.x, o.y, o.r, o.c, o.f
    end
  end
end

class Polyp
  require 'kdtree'

  attr_accessor :kd, :cells

  def initialize cell
    self.cells = {}
    grow cell
  end

  def grow cell
    new_key = cells.size + 1
    self.cells[new_key] = cell
    self.kd = Kdtree.new cell_data
    cell.calcify
  end

  def cell_data
    cells.map { |k, v| [v.x, v.y, k] }
  end

  def touching? cell
    b = cells[kd.nearest cell.x, cell.y]
    cell.position.distance_to(b) < cell.r + b.r
  end
end

class Difuso < Graphics::Simulation
  ANCHO, ALTO = 800, 800

  def initialize
    super ANCHO, ALTO

    add_walls

    b = Ball.new self.mod
    b.x, b.y = ANCHO/2, ALTO/2

    balls = [b]
    self.mod.polyp = Polyp.new b

    500.times do
      b = Ball.new self.mod
      b.x, b.y = 1 + rand(ANCHO - 2), 1 + rand(ALTO - 2)
      b.c = :red
      b.m = 1 + rand(4)
      b.a = rand 360
      balls << b
    end

    register_bodies balls
  end

  def draw n
    clear

    canvas.fps n, mod.start_time

    mod._bodies.each { |ary| draw_collection ary }
  end
end

Difuso.new.run
