class PackagePurchase < Purchase
  belongs_to :package_revision

  def package
    package_revision.package
  end

  def package=(object)
    self.package_revision = object.revision
  end

  def price
    package.price
  end

  def revision_data
    package_revision.package_data
  end
end
