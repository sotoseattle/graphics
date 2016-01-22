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
  # Aggregated vector of all interactions that affect the body.

  def resultant
    h = {}
    i = model.lines.each do |l|
      h[i] = l if i = intersection_point_with(l)
    end

    unless h.empty?
      i = h.keys.min { |j| position.distance_to j }
      return h[i].reaction_to(self)
    end

    nil
  end

  ##
  # Update the body's state (usually its vector) in two stages. Override.

  def interact
    self.velocity += self.acceleration

    while r = resultant
      r += model.gravity if model.gravity
      self.velocity += r
    end
  end

  def update
    move
  end

end
