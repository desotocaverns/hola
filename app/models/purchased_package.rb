class PurchasedPackage < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :package

  def total_price
    if quantity != nil
      quantity * package.price
    else
      0 * package.price
    end
  end
end
