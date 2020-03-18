require 'open-uri'
require 'pry'
require 'nokogiri'



class Scraper
  
  def self.scrape_index_page(index_url)
    html = open(index_url)
    students = []
    index = Nokogiri::HTML(html)
    index.css("div.student-card").each do |student|
      new_hash = {}
      new_hash[:name] = student.css("h4.student-name").text 
      new_hash[:location] = student.css("p.student-location").text
      new_hash[:profile_url] = student.css("a").attribute("href").value
      students << new_hash
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    index = Nokogiri::HTML(html)
    new_hash = {}
    index.css("div.social-icon-container a").each do |href|
      if href.attribute("href").value.include?("twitter")
        new_hash[:twitter] = href.attribute("href").value
      elsif href.attribute("href").value.include?("linkedin")
        new_hash[:linkedin] = href.attribute("href").value
      elsif href.attribute("href").value.include?("github")
        new_hash[:github] = href.attribute("href").value
      else 
        new_hash[:blog] = href.attribute("href").value
      end
      new_hash
    end
    
    new_hash[:profile_quote] = index.css("div.profile-quote").text
    new_hash[:bio] = index.css("div.description-holder p").text
    new_hash 
  end

end


