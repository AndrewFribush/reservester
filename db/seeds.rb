# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

kumas_owner = Owner.create(name: "Joe", email: "owner@kumas.com", password: "12345678")
csd_owner = Owner.create(name: "Frank", email: "owner@csd.com", password: "12345678")

kumas = Restaurant.create(
  name: "Kuma's", description: "Burgers",
  address: "123 Fake St.", phone_number: "123-123-1234",
  owner: kumas_owner)

Restaurant.create(
  name: "Kuma's Too", description: "Burgers & More",
  address: "666 Diversey St.", phone_number: "312-312-3124",
  owner: kumas_owner)

clark_street_dog = Restaurant.create(
  name: "Clark Street Dog", description: "Hot Dogs",
  address: "3150 N Clark", phone_number: "456-456-4567",
  owner: csd_owner)

Reservation.create(
  email: 'bob@gmail.com', requested_at: 1.day.from_now.to_datetime,
  restaurant_id: kumas.id)

Reservation.create(
  email: 'sally@gmail.com', requested_at: 1.day.from_now.to_datetime,
  restaurant_id: kumas.id)

Reservation.create(
  email: 'bob@gmail.com', requested_at: 1.day.from_now.to_datetime,
  restaurant_id: clark_street_dog.id)
