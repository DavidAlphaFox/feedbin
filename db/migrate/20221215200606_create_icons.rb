class CreateIcons < ActiveRecord::Migration[7.0]
  def change
    create_table :icons do |t|
      t.uuid :fingerprint, null: false, index: {unique: true}
      t.text :original_url
      t.text :storage_url
      t.timestamps
    end
  end
end
