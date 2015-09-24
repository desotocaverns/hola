module ApplicationHelper
  def price(num)
    "$#{num.to_int / 100.00}"
  end

  def iphone?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def edit_item_path(item)
    item.is_a?(Ticket) ? edit_ticket_path(item) : edit_package_path(item)
  end
end
