require 'rubygems'
require 'mechanize'

agent = Mechanize.new

page = agent.get('https://www.archdaily.com/category/landscape-architecture')

images = page.search(".afd-search-list__im")

titles = page.search(".afd-search-list__title")

images.count.times do |i|
  agent.get(images[i - 1].attributes["src"]).save "app/assets/images/#{i}_pic.jpeg"
  titles.first.children.first.text.strip
end