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

  def calculate_expiration_date
    package_revision = PackageRevision.find(self.package_revision_id)
    package = Package.find(package_revision.package_id)
    expiration_date = Date.today + package.validity_interval
    self.expires_on = expiration_date
  end
end
