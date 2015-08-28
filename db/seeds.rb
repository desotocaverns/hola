# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

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
