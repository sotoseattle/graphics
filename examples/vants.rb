#!/usr/local/bin/ruby -w
# -*- coding: utf-8 -*-

srand 42

# require "graphics"
require_relative "../lib/graphics"
require './lib/graphics/dynamic.rb'
require 'set'

##
# Virtual Ants -- inspired by a model in NetLogo.

class Vant < Graphics::Body
  include Dynamic

  COUNT = 1000
  M = 1

  attr_accessor :red

  def initialize model
    super

    self.velocity = V.new_polar(rand(360.0), M)
    model.screen << [x, y]
  end

  def interact
    move
  end

  def update
    if model.screen.include? [x, y]
      model.screen.delete [x, y]
       turn 270
    else
      model.screen << [x, y]
      turn 90
    end
  end

  def turn beta
    alpha = velocity.cart_to_polar[:a]
    self.velocity = V.polar_to_cart (alpha +  beta).degrees, M
  end
end

class Vants < Graphics::Simulation
  attr_accessor :vs

  def initialize
    super 850, 850, 16, self.class.name

    self.model.screen = Set.new

    register_bodies populate Vant
  end

  def draw n
    clear :white

    model.screen.each do |x, y|
      canvas.point x, y, :black
    end
  end
end

Vants.new.run if $0 == __FILE__
