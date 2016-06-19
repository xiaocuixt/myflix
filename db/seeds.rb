# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create([{id: 1, name: "TV Commedies"}, {id: 2, name: "TV Dramas"}, {id: 3, name: "Reality TV"}])

fut = Video.create(title: "Futurama", description: "Space Trval!", large_cover_url: "/tmp/monk.jpg", category_id: 1)
back = Video.create(title: "Back to Future", description: 'Time Trval!', large_cover_url: "/tmp/family_guy.jpg", category_id: 2)

xiaocui = User.create(email: "cjw624923@gmail.com", password: "12345678", full_name: "xiaocui")

Review.create(user: xiaocui, video: back, content: "this is really nice movie!", rating: 5)
Review.create(user: xiaocui, video: fut, content: "this is horrible movie!", rating: 3)