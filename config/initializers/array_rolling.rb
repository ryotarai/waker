class Array
  def rolling!(*position)
    a = position[0] || 0
    b = position[1] || self.count-1
    raise ArgumentError unless a.between?(0, self.count-1) && b.between?(0, self.count-1)

    self.insert(a, self.delete_at(b))
  end

  def rolling(*position)
    self.dup.rolling!(*position)
  end
end
