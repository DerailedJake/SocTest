require 'rubygems'
require 'mechanize'

agent = Mechanize.new

website_pages = [
  'https://www.archdaily.com/category/landscape-architecture',
  'https://www.archdaily.com/category/landscape-architecture/page/2',
  'https://www.archdaily.com/category/landscape-architecture/page/3',
  'https://www.archdaily.com/category/landscape-architecture/page/4'
]

image_count = 1

website_pages.each do |single_page|
  page = agent.get(single_page)

  images = page.search(".afd-search-list__img")

  images_links = images.map{|i| i.attribute_nodes[1].value }

  images_links.map! { |s| s.sub('small_jpg', 'newsletter') }

  titles_raw = page.search(".afd-search-list__title")

  p images.count

  p titles_raw.count

  images.count.times do |i|
    p 'kurwa :)'
    sleep 0.5
    titles = titles_raw.map { |t| t.children.first.text.strip }
    titles.map! { |t| t.split('/')[0].strip }
    title = titles[i - 1].gsub(/\s+/, "_")

    agent.get(images_links[i - 1]).save "app/assets/images/post_pictures/#{title}_#{image_count}_pic.jpeg"
    image_count += 1
  end
end
