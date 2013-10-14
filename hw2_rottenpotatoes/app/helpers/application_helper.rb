module ApplicationHelper
  def highliter(sortedField)
    case sortedField
    when "title"
      @titleClass = "hilite"
    when "release_date"
      @dateClass = "hilite"
    when "rating"
      @ratingClass = "hilite"
    end
  end
end
