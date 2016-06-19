Fabricator(:review) do
  rating {(1..5).to_a.sample}
  content {Faker::Lorem.paragraphs(3)}
end