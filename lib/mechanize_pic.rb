
architecture_scraper = false
food_scraper = false

if architecture_scraper
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
end

if food_scraper
  require 'rubygems'
  require 'mechanize'
  agent = Mechanize.new

  website_pages = [
    'https://picography.co/category/food/',
    'https://picography.co/category/food/page/2',
    'https://picography.co/category/food/page/3',
    'https://picography.co/category/food/page/4',
    'https://picography.co/category/food/page/5',
    'https://picography.co/category/food/page/6',
    'https://picography.co/category/food/page/7',
    'https://picography.co/category/food/page/8',
    'https://picography.co/category/food/page/9'
    # 'https://unsplash.com/s/photos/delicious-food'
  ]

  image_count = 1

  website_pages.each do |single_page|
    page = agent.get(single_page)

    images = []
    raw_images = page.images

    raw_images.each { |i| images << i if i.src.include?('600x400') }

    p images.count

    images.each do |image|
      p 'kurwa :)'
      sleep 0.2
      agent.get(image).save "app/assets/images/post_pics_food/#{image.text}_#{image_count}_pic.jpeg"
      image_count += 1
    end
  end
end
