class ChangePubTypeOnArticleToReference < ActiveRecord::Migration
  def change
    remove_column :articles, :pub

    change_table :articles do |t|
      t.references :publication
    end
  end
end
