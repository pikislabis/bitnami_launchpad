class CreateInstances < ActiveRecord::Migration[5.2]
  def change
    create_table :instances do |t|
      t.string :instance_id
      t.string :instance_status
      t.string :encrypted_access_key_id
      t.string :encrypted_access_key_id_iv
      t.string :encrypted_secret_access_key
      t.string :encrypted_secret_access_key_iv

      t.timestamps
    end
  end
end
