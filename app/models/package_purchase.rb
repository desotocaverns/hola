class PackagePurchase < Purchase
  belongs_to :package_revision

  def package
    package_revision.package
  end

  def price
    package.price
  end
end
