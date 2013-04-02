class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :domain
      t.string :formatted_name

      t.timestamps
    end

    add_index :publications, :domain
  end
end
