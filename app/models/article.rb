require 'open-uri'

class Article < ActiveRecord::Base
  attr_accessible :author, :brief, :date, :headline, :mentions, :pub, :tags, :url

  def monkey_work!
    doc = Nokogiri::HTML(open(self.url))

    self.headline = find_headline(doc)
    self.author = find_author(doc)
    self.date = find_date(doc)
    self.pub = find_pub(self.url)

    self.save!
  end

  private

  def find_headline(doc)
    selectors = ["h1"]

    search_through(doc, selectors).titleize
  end

  def find_author(doc)
    selectors = [".byline", ".author", ".vcard"]

    search_through(doc, selectors)
  end

  def find_date(doc)
    date = doc.at_css('.published')["title"]

    if date
      date
    else
      ""
    end
  end

  def find_pub(url)
    get_host_without_www(url)
  end

  def get_host_without_www(url)
    url = "http://#{url}" unless url.start_with?('http')
    uri = URI.parse(url)
    host = uri.host.downcase
    host.start_with?('www.') ? host[4..-1] : host
  end

  def search_through(doc, selectors)
    selectors.each do |s|
      data = doc.at_css(s)
      if data.present?
        return data.content
      end
    end
  end
end
