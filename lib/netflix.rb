class Netflix < MovieCollection
  class NotEnoughMoney < RuntimeError; end
  class MovieNotFound < RuntimeError; end

  attr_reader :money
  PRICE = { ancient: 1, classic: 1.5, modern: 3, new: 5 }

  def initialize(file_name)
    super(file_name)
    @money = 0
  end

  def pay(amount)
    @money += amount
  end

  def how_much?(title)
    movie = filter(title: title).first
    raise MovieNotFound if movie.nil?
    PRICE[movie.period]
  end

  def show(period:, **facets)
    withdraw(PRICE[period])
    movie = filter(facets.merge(period: period)).sample
    puts "Now showing: #{movie.title}"
    movie
  end

  private

  def withdraw(amount)
    raise NotEnoughMoney if @money < amount
    @money -= amount
  end

end