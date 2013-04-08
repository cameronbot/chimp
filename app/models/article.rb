require 'open-uri'

class Article < ActiveRecord::Base
  attr_accessible :author, :brief, :date, :headline, :mentions, :publication, :url, :tag_list, :mentions
  attr_accessible :matches, :report
  belongs_to :publication
  belongs_to :report
  acts_as_taggable_on :tags

  def monkey_work!
    doc = Nokogiri::HTML(open(self.url))
    doc = check_for_meta_redirect(doc)

    self.headline = find_headline(doc)
    self.author = find_author(doc)
    self.date = find_date(doc)
    self.publication = find_pub(self.url)
    self.url = find_canonical(doc)

    words = ["ACLU", "American Civil Liberties"]
    self.matches = find_keywords(doc, words)

    self.save!
  end

  private

  def find_headline(doc)
    selectors = [".entry-title", ".content h1", "#content h1", "h1"]

    search_through(doc, selectors).titleize
  end

  def find_author(doc)
    selectors = [".byline", ".author", ".vcard"]

    # these downcased noisy words will be removed from our matched string
    noise = ["posted", "by:", "by"]

    author = search_through(doc, selectors)

    # strip any email address
    author = author.sub(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i, "").strip

    # remove clutter words (ex. Posted by:)
    author = author.split(" ")
    downcase = author.map(&:downcase)

    author.delete_if { |x| noise.include? x.downcase }
    author.join(" ")
  end

  def find_date(doc)
    selectors = [".published", ".date", ".articleDate"]

    date = search_through(doc, selectors)

    if date
      date
    else
      ""
    end
  end

  def find_pub(url)
    domain = get_host_without_www(url)

    Publication.find_or_create_by_domain(domain)
  end

  def find_canonical(doc)
    canonical_tag = doc.at('link[rel="canonical"]')

    if canonical_tag
      canonical_tag['href']
    else
      self.url
    end
  end

  def find_keywords(doc, keywords)
    paragraphs = doc.css('p')

    hash = Hash.new
    paragraphs.each do |p|
      keywords.each do |k|
        if p.content.include? k
          hash[k] = hash[k].to_i + 1
        end
      end
    end

    hash.to_json
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

    ""
  end

  def check_for_meta_redirect(doc)
    meta_refresh_tag = doc.at('meta[http-equiv="refresh"]')

    if meta_refresh_tag && (not meta_refresh_tag.path().include? "noscript")
      redirect_url = meta_refresh_tag['content'][/url=(.+)/, 1]
      self.url = redirect_url

      doc = check_for_meta_redirect(Nokogiri::HTML(open(redirect_url)))
    end

    doc
  end
end
