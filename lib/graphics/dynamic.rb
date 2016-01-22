# require 'grpahics/segment'
require_relative './segment'

module Dynamic
  attr_accessor :velocity, :acceleration

  def initialize mod
    super mod
    self.velocity = V[0.0, 0.0]
    self.acceleration = V[0.0, 0.0]
  end

  ##
  # Estimated linear trajectory.

  def trajectory
    Segment.new position, endpoint
  end

  ##
  # Intersection of vector and segment.

  def intersection_point_with o
    self.trajectory.intersection_point_with(o.trajectory)
  end

  ##
  # Resultant vector from closest interacting object.

  def resultant_over klass
    if bouncer = closest_interactor(possible_actors_of klass)
      bouncer.reaction_to(self)
    else
      nil
    end
  end

  def possible_actors_of klass
    model._bodies.select { |arr| arr.first.is_a? klass }.flatten
  end

  def closest_interactor actors
    min_dist = Float::MAX
    closest  = nil

    actors.each do |o|
      if i = intersection_point_with(o)
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
    self.velocity += self.acceleration

    while r = resultant_over(Wall)
      r += model.gravity if model.gravity
      self.velocity += r
    end
  end

  def update
    move
  end

end
