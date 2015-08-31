# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

adult_tour = Ticket.create!(
	name: "Adult Caverns Tour",
	price: 2199,
	description: "Adult Caverns Tour"
)

child_tour = Ticket.create!(
	name: "Child Caverns Tour",
	price: 1799,
	description: "Children 2 and under tour free when accompanied by an adult."
)

attraction = Ticket.create!(
	name: "Attraction",
	price: 499,
	description: "Attraction"
)

package = Package.new(
	name: "Attraction 5 Pac",
	price: 2249,
	description: "Five attractions for less that 5 * Attraction!"
)

package.package_tickets << PackageTicket.new(ticket: attraction, quantity: 5)

package.save!

Admin.create!(
  email: "brandon@desotocavernspark.com",
  password: "brandonspw",
  activated: true
)

Admin.create!(
  email: "isaac@thewilliams.ws",
  password: "isaacspw",
  activated: true
)
