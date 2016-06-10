# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Video.destroy_all
Category.destroy_all
Video.create([
	{title: "Futurama", description: "Space Trval!", cover_image_url: "/tmp/monk.jpg", category_id: 1},
	{title: "Back to Future", description: 'Time Trval!', cover_image_url: "/tmp/family_guy.jpg", category_id: 2}
])
Category.create([{id: 1, name: "TV Commedies"}, {id: 2, name: "TV Dramas"}, {id: 3, name: "Reality TV"}])