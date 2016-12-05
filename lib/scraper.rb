require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").collect do |student|
      {
        :name => student.css("a div.card-text-container h4").text,
        :location => student.css("a div.card-text-container p").text,
        :profile_url => "./fixtures/student-site/" + student.css("a").attribute("href").value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}

    doc.css("div.social-icon-container a").each do |info|
      href = info.attribute("href").value
      if href.include?("twitter")
        student[:twitter] = href
      elsif href.include?("linkedin")
        student[:linkedin] = href
      elsif href.include?("github")
        student[:github] = href
      else
        student[:blog] = href
      end
    end
    student[:profile_quote] = doc.css("div.profile-quote").text
    student[:bio] = doc.css("div.description-holder p").text

    student
  end

end

Scraper.new
