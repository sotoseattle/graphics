require './lib/graphics.rb'
require './lib/graphics/linear_motion.rb'

class Ball < Graphics::Body
  include LinearMotion

  attr_accessor :c, :r, :store

  def initialize sim_env
    super sim_env
    self.r = 2
  end

  def tick
    return if calcified?
    super
  end

  def tock
    return if calcified?

    if self.store = mod.polyp.touching(self)
      mod.polyp.attach self
    else
      move
    end
  end

  def calcify
    self.m = 0
  end

  def calcified?
    m == 0
  end

  def touches other
    position.distance_to(other) <= r + other.r
  end

  class View
    def self.draw w, o
      if o.store
        w.line o.x, o.y, o.store.x, o.store.y, :green
      end

      unless o.calcified?
        w.circle o.x, o.y, o.r, o.c
      end
    end
  end
end

class Polyp
  require 'kdtree'

  attr_accessor :kd, :cells

  def initialize cell
    self.cells = {}
    attach cell
  end

  def attach cell
    cells[cells.size] = cell
    self.kd = Kdtree.new cell_data
    cell.calcify
  end

  def cell_data
    cells.map { |k, v| [v.x, v.y, k] }
  end

  def touching cell
    nearest = cells[kd.nearest cell.x, cell.y]
    return nearest if cell.touches nearest
    nil
  end
end

class Difuso < Graphics::Simulation
  ANCHO, ALTO = 800, 800

  def initialize
    super ANCHO, ALTO

    add_walls

    seed = Ball.new self.mod
    seed.x, seed.y = ANCHO/2, ALTO/2

    balls = [seed]

    self.mod.polyp = Polyp.new seed

    500.times do
      b = Ball.new self.mod
      b.x, b.y = rand(1..ANCHO - 1), rand(1..ALTO - 1)
      b.c = :red
      b.m = 1 + rand(9)
      b.r = 2 + rand(7)
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
