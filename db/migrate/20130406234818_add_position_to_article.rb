class AddPositionToArticle < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.references :report
      t.integer :position
    end
  end
end
