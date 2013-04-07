module ArticulatorHelper
  def formatted_brief(article)
    bold_words = ["ACLU of California", "ACLU of Northern California", "ACLU"]

    article.mentions && article.mentions.split(" ").map do |m|
      bold_words << m.titlecase unless m.include? "ACLU"
    end

    article.brief && bold_words.each do |w|
      article.brief.gsub! w, "<b>#{w}</b>"
    end

    article.brief ? article.brief.html_safe : ""
  end
end
