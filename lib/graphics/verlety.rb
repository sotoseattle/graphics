# require 'grpahics/segment'
require_relative './segment'

module Verlety
  attr_accessor :prevpos, :acceleration

  def initialize mod
    super mod
    self.prevpos = position
    self.acceleration = V[0.0, 0.0]
  end

  def velocity
    position - prevpos
  end

  def velocity= v
    self.prevpos = position
    self.position += v
  end

  ##
  # Estimated linear trajectory.

  def trajectory
    Segment.new prevpos, position
  end

  ##
  # Intersection of vector and segment.

  def intersection_point_with segment, ojeto
    segment.intersection_point_with(ojeto.trajectory)
  end

  ##
  # Resultant vector from closest interacting object.

  def reaction klass, path = self.trajectory
    if obstacle = closest_interactor(path, possible_actors_of(klass))
      obstacle.reaction_to(self)
    else
      nil
    end
  end

  def possible_actors_of klass
    model._bodies.select { |arr| arr.first.is_a? klass }.flatten
  end

  def closest_interactor seg, actors
    min_dist = Float::MAX
    closest  = nil

    actors.each do |o|
      if i = intersection_point_with(seg, o)
        dist = position.distance_to(i)
        if dist < min_dist
          min_dist = dist
          closest = o
        end
      end
    end

    closest
  end

  ##
  # Update the body's state (usually its vector) in two stages. Override.

  def interact
    while r = reaction(Wall)
      self.velocity += r
    end
  end

  def update a = 2.0, b = 1.0
    self.position, self.prevpos =                    \
      (position * a) - (prevpos * b) + acceleration, \
      position
  end
end
