class AncientMovie < Movie
  def to_s
    "#{title} - старый фильм (#{year})"
  end
end