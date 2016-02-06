# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Tickets and packages
adult_tour = Ticket.create!(
  name: "Adult Caverns Tour",
  price: 2199,
  description: "A one-hour, guided tour through DeSoto Caverns",
  for_sale_on: Time.now
)

child_tour = Ticket.create!(
  name: "Child Caverns Tour",
  price: 1799,
  description: "Ages 3-11 (Children 2 and under are free)",
  for_sale_on: Time.now
)

attraction = Ticket.create!(
  name: "Attraction Ticket",
  price: 499,
  description: "Admission to one of over 25 unique attractions",
  for_sale_on: Time.now
)

fun_pac = Package.new(
  name: "Explorer Fun Pac",
  price: 2899,
  description: "One caverns tour and 5 attraction tickets",
  for_sale_on: Time.now
)

fun_pac.package_tickets << PackageTicket.new(ticket: attraction, quantity: 5)
fun_pac.package_tickets << PackageTicket.new(ticket: adult_tour, quantity: 1)

fun_pac.save!


attraction_package = Package.new(
  name: "Attraction 5 Pac",
  price: 2249,
  description: "Five attractions tickets",
  for_sale_on: Time.now
)

attraction_package.package_tickets << PackageTicket.new(ticket: attraction, quantity: 5)

attraction_package.save!

# Base settings
Settings.create!()

# Sales and Purchases
sale = Sale.new(
  name: "Arnold",
  email: "arnold@schwarzenegger.ws",
  charge_id: "ch_16ZSOgJiVRz9VXanvB8T1RG7",
  mailing_list: true
)

sale.purchases << TicketPurchase.new(ticket: attraction, quantity: 2)
sale.purchases << TicketPurchase.new(ticket: adult_tour, quantity: 1)
sale.save!

# Admins
Admin.create!(
  email: "test@desotocaverns.com",
  password: "testpass",
  activated: true,
  autocratic: true
)

Admin.create!(
  email: "scanner@desotocaverns.com",
  password: "testpass",
  activated: true
)
