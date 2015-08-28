class PackageRevision < ActiveRecord::Base
  store_accessor :package_data, :description, :price

  def tickets
  	package_data["tickets"].map do |td|
  	  Ticket.new(td).tap {|t| t.readonly! }
  	end
  end
end
