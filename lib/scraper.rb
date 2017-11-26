require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    scraped_students = []

    doc.css(".student-card").each do |project|

      scraped_students << {
        :name => project.css(".student-name").text,
        :location => project.css(".student-location").text,
        :profile_url => project.css("a").attribute("href").text
      }
    end

    scraped_students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    scraped_student = {}

    test = doc.css(".social-icon-container a").map {|c| c.attribute("href").value}

      test.each do |link|
      if link.include?("twitter")
        scraped_student[:twitter] = link
      elsif link.include?("github")
        scraped_student[:github] = link
      elsif link.include?("linkedin")
        scraped_student[:linkedin] = link
      elsif link.include?("http:")
        scraped_student[:blog] = link
      end
      scraped_student[:profile_quote] = doc.css(".profile-quote").text
      scraped_student[:bio] = doc.css(".description-holder p").text
  end

  scraped_student
end

end
