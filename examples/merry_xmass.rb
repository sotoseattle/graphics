# require 'graphics.rb'
require_relative '../lib/graphics.rb'
require_relative '../lib/graphics/rainbows'
require './lib/graphics/dynamic.rb'

class Ball < Graphics::Body
  include Dynamic

  attr_accessor :c, :r, :store, :leaf

  COUNT = 1_000
  PURPLISH = "cubehelix_280".to_sym

  def initialize model
    super

    a = 225 + rand(90)
    m = 2 + rand(9)
    self.velocity = V.new_polar(a, m)
    self.r = m

    self.c = "cubehelix_#{160 + rand(200)}".to_sym
    self.store = self
    self.leaf = false
  end

  def interact
    return if calcified?

    self.store = nil
    if self.store = model.polyp.touching(self)
      model.polyp.attach self
      self.leaf = true
      self.store.leaf = false
    end
  end

  def update
    move
    wrap
  end

  def calcify
    self.velocity = V[0.0, 0.0]
  end

  def calcified?
    self.velocity.magnitude == 0.0
  end

  def touches other
    position.distance_to(other) <= (r + other.r)
  end

  class View
    def self.draw w, o
      if o.calcified?
        w.line o.x, o.y, o.store.x, o.store.y, PURPLISH

        if o.leaf
          w.circle o.x, o.y, o.r, o.c, :true
          w.circle o.x, o.y, o.r, :gray
        end
      else
          w.circle o.x, o.y, o.r, o.c, :true
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

class MerryXmass < Graphics::Simulation

  attr_accessor :spectrum

  def initialize
    super 700, 700

    self.spectrum = Graphics::Cubehelix.new
    self.initialize_rainbow spectrum, "cubehelix"

    seed = Ball.new self.model
    seed.x, seed.y = model.w/2, 2

    model.polyp = Polyp.new seed

    balls = [seed]
    balls += populate Ball
    register_bodies balls
  end
end

MerryXmass.new.run
