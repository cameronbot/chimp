class AddMatchesToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :matches, :text
  end
end
