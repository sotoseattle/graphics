#!/usr/local/bin/ruby -w

# require "graphics"
require_relative "../lib/graphics"
require './lib/graphics/dynamic.rb'

class Tank < Graphics::Body
  include Dynamic

  COUNT = 8

  attr_accessor :sprite, :cmap, :updated

  def initialize e
    super e

    self.velocity = V.new_polar rand(360), 5
    self.updated = false
  end

  def spritify img
    self.sprite = img
    self.cmap = img.make_collision_map
  end

  def update
    move
    self.updated = false
  end

  def interact
    super

    if !self.updated
      crashing = model._bodies.flatten.select { |t| collide_with? t }

      crashing.each(&:veer) if crashing.size > 1
    end
  end

  def veer
    self.velocity *= -1
    self.updated = false
  end

  def collide_with? other
    self.cmap.check self.endpoint.x, self.endpoint.y,  \
                    other.cmap,                        \
                    other.endpoint.x, other.endpoint.y
  end

  def direction
    velocity.cart_to_polar[:a]
  end

  class View
    def self.draw w, o
      w.blit o.sprite, o.x, o.y, o.direction
      w.fps o.model.n, o.model.start_time
    end
  end
end

class Collision < Graphics::Simulation
  def initialize
    super 800, 800, 16, "Collision"

    add_walls

    tank_img = image "resources/images/body.png"

    register_bodies  populate(Tank) { |b| b.spritify tank_img }
  end

  def inspect
    "<Screen ...>"
  end
end

Collision.new.run
