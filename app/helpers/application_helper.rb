module ApplicationHelper
  def price(num)
    "$#{num.to_int / 100.00}"
  end

  def iphone?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end
end
