class AddMetadataToHits < ActiveRecord::Migration
  def up
    add_column      :hits, :receiver_model,  :string
    add_column      :hits, :receiver_serial, :string
    remove_column   :hits, :receiver_code
  end

  def down
    remove_column   :hits, :receiver_model
    remove_column   :hits, :receiver_serial
    add_column      :hits, :receiver_code,  :string
  end
end
