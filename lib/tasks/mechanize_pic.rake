require 'rubygems'
require 'mechanize'

agent = Mechanize.new

page = agent.get('https://www.archdaily.com/category/landscape-architecture')

images = page.search(".afd-search-list__img")


titles_raw = page.search(".afd-search-list__title")
p images.count
p titles_raw.count
images.count.times do |i|
  p 'kurwa'
  titles = titles_raw.map { |t| t.children.first.text.strip }
  titles.map! { |t| t.split('/')[0].strip }
  title = titles[i - 1].gsub(/\s+/, "_")

  agent.get(images[i - 1].attributes["src"]).save "app/assets/images/#{title}_#{i}_pic.jpeg"
end