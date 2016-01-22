# require 'graphics.rb'
require_relative '../lib/graphics.rb'
require_relative '../lib/graphics/rainbows'
require './lib/graphics/dynamic.rb'

class Ball < Graphics::Body
  include Dynamic

  attr_accessor :c, :r, :store

  COUNT = 1_000

  def initialize model
    super

    m = 2 + rand(9)
    self.velocity = V.new_polar(a = rand(360.0), m = m)
    self.r = m

    self.c = "cubehelix_#{160 + rand(200)}".to_sym
    self.store = self
  end

  def interact
    return if calcified?
    super

    if self.store = model.polyp.touching(self)
      model.polyp.attach self
    end
  end

  def update
    move
  end

  def calcify
    self.velocity = V[0.0, 0.0]
  end

  def calcified?
    self.velocity == V[0, 0]
  end

  def touches other
    position.distance_to(other) <= (r + other.r)
  end

  class View
    def self.draw w, o
      if o.calcified?
        w.line o.x, o.y, o.store.x, o.store.y, o.c
        w.circle o.x, o.y, o.r/3, :gray
      else
        w.circle o.x, o.y, o.r, o.c, :fill
      end
    end
  end
end

class Polyp
  require 'kdtree'

  attr_accessor :kd, :cells

  def initialize cell
    self.cells = []
    attach cell
  end

  def attach cell
    cells << cell
    self.kd = Kdtree.new cell_data
    cell.calcify
  end

  def cell_data
    cells.map.with_index { |c, i| [c.x, c.y, i] }
  end

  def touching cell
    nearest = cells[kd.nearest cell.x, cell.y]
    return nearest if cell.touches nearest
    nil
  end
end

class Difuso < Graphics::Simulation

  attr_accessor :spectrum

  def initialize
    super 800, 800

    self.spectrum = Graphics::Cubehelix.new
    self.initialize_rainbow spectrum, "cubehelix"

    add_walls

    seed = Ball.new self.model
    seed.x, seed.y = model.w/2, model.h/2

    model.polyp = Polyp.new(seed)

    balls = [seed]
    balls += populate Ball do |b|
      b.x, b.y = rand(model.w/4..model.w*3/4), rand(1..model.h/4)
    end

    register_bodies balls
  end
end

Difuso.new.run
