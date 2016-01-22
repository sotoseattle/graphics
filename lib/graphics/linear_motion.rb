# require 'grpahics/segment'
require_relative './segment'

# TODO: THIS IS A MESS. BEWARE!!

module LinearMotion

  def point1
    position
  end

  def point2
    endpoint
  end

  ##
  # Estimated linear trajectory.

  def trajectory
    Segment.new point1, point2
  end

  # Intersection of vector and segment.

  def intersection_point_with o
    if  o.is_a?(Graphics::Body) && self.dot_product(o) == 0
      s = self.trajectory
      if Segment.have_intersecting_bounds?(s, o) && s.overlaps?(o)
        return position
      end
    end

    self.trajectory.intersection_point_with(o)
  end

  # def reaction_to o
  #   d = o.dup
  #   d.a += 180
  #   self + d
  # end

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

end
