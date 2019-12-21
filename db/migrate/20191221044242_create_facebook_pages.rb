class CreateFacebookPages < ActiveRecord::Migration[5.1]
  def change
    create_table :facebook_pages do |t|
    	t.string :page_id
      t.string :avatar_url
      t.string :page_url
      t.string :name
      t.string :page_token
      t.references :user, foreign_key: true
      t.boolean :enable

      t.timestamps
    end
  end
end
