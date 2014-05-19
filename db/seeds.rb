# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!  email:  "jambon.beurre@yopmail.com",
              name:   "Jambon Beurre",
              password: 'yopmail',
              password_confirmation: 'yopmail'

User.create!  email:  "jack.morris-34lw6rc@yopmail.com",
              name:   "Jack Morris",
              password: 'yopmail',
              password_confirmation: 'yopmail'
