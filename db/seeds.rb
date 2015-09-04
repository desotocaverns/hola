# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Tickets and packages
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

attraction_package = Package.new(
	name: "Attraction 5 Pac",
	price: 2249,
	description: "Five attractions for less that 5 * Attraction!"
)

attraction_package.package_tickets << PackageTicket.new(ticket: attraction, quantity: 5)

attraction_package.save!

fun_pac = Package.new(
  name: "Fun Pac",
  price: 2999,
  description: "All the fun!"
)

fun_pac.package_tickets << PackageTicket.new(ticket: attraction, quantity: 3)
fun_pac.package_tickets << PackageTicket.new(ticket: adult_tour, quantity: 1)

fun_pac.save!

# Sales and Purchases
sale = Sale.new(
  name: "Arnold",
  email: "arnold@schwarzenegger.ws",
  charge_id: "ch_16ZSOgJiVRz9VXanvB8T1RG7"
)

sale.purchases << TicketPurchase.new(ticket: attraction, quantity: 2)
sale.purchases << TicketPurchase.new(ticket: adult_tour, quantity: 1)
sale.save!

# Admins
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
