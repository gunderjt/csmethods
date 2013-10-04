class Dessert

  attr_reader :name, :calories

  def initialize(name, calories)
    @name = name
    @calories = calories
  end

  def healthy?
    if @calories < 200
      return true
    else
      return false
    end
  end

  def delicious?
    return true
  end
end


class JellyBean < Dessert
  def initialize(name, calories, flavor)
    super(name, calories)
    @flavor = flavor
  end

  def delicious?
    if @flavor == "Black Liquorice"
      return false
    else
      return true
    end
  end
end

d = Dessert.new("pie", 300)
puts d.name
puts d.calories
puts d.delicious?
puts d.healthy?
j = JellyBean.new("green", 50, "mint")
puts j.name
puts j.calories
puts j.delicious?
puts j.healthy?
l = JellyBean.new("black", 50, "Black Liquorice")
puts l.name
puts l.calories
puts l.delicious?
puts l.healthy?
