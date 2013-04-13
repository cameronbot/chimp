# encoding: UTF-8
require 'spec_helper'

describe 'The chimp app', vcr: true do
  before do
    visit '/'
  end

  context "parses an article" do
    before do
      fill_in 'article_url', with: "http://www.asianweek.com/2013/03/07/smaller-cpmc-between-japantown-little-saigon/"
      click_button "Go"
    end

    it "without a hangup" do
      page.should have_content I18n.t 'parse_article.flash.success'
    end

    it "finds the headline" do
      find_field("article_headline").value.should eq "Smaller Cpmc Between Japantown & Little Saigon"
    end

    # find a way to pass in a flag or something to not load the iframe
    it "capitalizes a lowercase headline", js: true do
      fill_in 'article_headline', with: "lazy headline"
      click_button I18n.t 'parse_article.entry_form.format_headline'
      find_field("article_headline").value.should eq "Lazy Headline"
    end
  end
end
