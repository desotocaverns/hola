module SalesHelper
  def collect_quantity_path
    @sale.new_record? ? sales_path : sales_update_quantities_path
  end

  def collect_quantity_method
    @sale.new_record? ? :create : :patch
  end
end
