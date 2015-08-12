# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Package.create(
  title: "Adult Caverns Tour",
  description: "",
  price: 2199,
  cavern_tours: 1,
  attractions: 0,
  for_sale: true
)

Package.create(
  title: "Child Caverns Tour",
  description: "",
  price: 1799,
  cavern_tours: 1,
  attractions: 0,
  for_sale: true
)

Package.create(
  title: "Attraction Ticket",
  description: "",
  price: 499,
  cavern_tours: 0,
  attractions: 1,
  for_sale: true
)

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
