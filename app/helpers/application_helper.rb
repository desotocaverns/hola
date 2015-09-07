module ApplicationHelper
  def price(num)
    "$#{num.to_int / 100.00}"
  end
end
