class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :idol_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :idol_id
    add_index :relationships, [:follower_id, :idol_id], unique: true
  end
end
