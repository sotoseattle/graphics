require_relative './geometria'

module LinearMotion
  include Geometria

  # attr_accessor :r

  def point1
    position
  end

  def point2
    endpoint  # TODO: way too much computation: bag it!
  end


  # Intersection of vector and segment.

  def intersection_point_with o
    if  o.is_a?(Graphics::Body) && self.dot_product(o) == 0
      s = self.to_seg
      if Geometria.have_intersecting_bounds?(s, o) && s.overlaps?(o)
        return position
      end
    end

    self.to_seg.intersection_point_with(o)
  end

  def reaction_to o
    d = o.dup
    d.a += 180
    self + d
  end

  ##
  # Aggregated vector of all interactions that affect the body.

  def resultant
    h = {}
    i = mod.lines.each do |l|
      h[i] = l if i = intersection_point_with(l)
    end

    unless h.empty?
      i = h.keys.min { |i| position.distance_to i }
      return h[i].reaction_to(self)
    end

    nil
  end

  ##
  # Take into consideration all possible interactions. Override to extend.

  def tick
    res = true
    while res
      res = resultant
      self.apply(res) if res
    end
     # self.r = resultant if m
  end

  def tock
    move
    # if r
    #   self.apply(r)
    # else
    #   move
    #   self.r = nil
    # end
  end

end
