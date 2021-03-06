module ApplicationHelper

  def price(num)
    "$#{price_number(num)}"
  end

  def price_number(num)
    p = "#{num.to_int / 100.00}"
    p += '0' if p =~ /\..$/
    p
  end

  def protohost
    return request.protocol + request.host unless request.nil? || request.local?
    return "http://localhost:3000"
  end

  def iphone?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def edit_item_path(item)
    item.is_a?(Ticket) ? edit_ticket_path(item) : edit_package_path(item)
  end

  def auto_tickets_path(item)
    item.for_sale_on == nil || item.for_sale_on >= Time.now ? nfs_index_path : tickets_path
  end

  def action_heading(heading, link_text, link_path)
    render partial: "shared/action_heading", locals: { heading: heading, link_text: link_text, link_path: link_path }
  end

  def is_admin?
    admin_signed_in? && current_admin.autocratic
  end
end
