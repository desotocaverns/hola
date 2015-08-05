class PurchasedPackage < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :package

  def total_price
    quantity * package.price
  end
end
