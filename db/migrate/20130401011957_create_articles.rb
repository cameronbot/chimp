class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :url
      t.string :headline
      t.date :date
      t.text :brief
      t.string :author
      t.string :pub
      t.string :mentions
      t.string :tags

      t.timestamps
    end
  end
end
