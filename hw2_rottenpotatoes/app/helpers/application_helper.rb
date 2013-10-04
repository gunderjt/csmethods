module ApplicationHelper
  def titleClass
    if current_page?(type: 'title')
      hilite
    end
  end
  def dateClass
    if current_pate?(type: 'release_date')
      hilite
    end
  end
end
