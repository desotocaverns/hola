module SalesHelper
  def collect_quantity_path
    @sale.new_record? ? sales_path : sales_update_cart_path
  end

  def collect_quantity_method
    @sale.new_record? ? :create : :patch
  end

  def cart_items
    @sale.purchases.map(&:quantity).reduce(:+)
  end

  def cart_packages
    @sale.purchases.where(type: PackagePurchase)
  end

  def cart_tickets
    @sale.purchases.where(type: TicketPurchase)
  end

  def personal_info
    if @sale.email != nil
      render(partial: 'static_personal_info')
    else
      render(partial: 'personal_info_form')
    end
  end
end
