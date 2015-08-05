class Package < ActiveRecord::Base
  scope :for_sale, -> { where(for_sale: true) }
end
