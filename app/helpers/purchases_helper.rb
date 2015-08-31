module PurchasesHelper
  def collect_quantity_path
    @sale.new_record? ? purchases_path : purchases_update_quantities_path
  end

  def collect_quantity_method
    @sale.new_record? ? :create : :patch
  end
end
