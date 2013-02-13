class AddHitsTables < ActiveRecord::Migration
  def change

    create_table(:hits) do |t|
      t.integer             :deployment_id
      t.string              :deployment_code
      t.integer             :tag_deployment_id
      t.string              :tag_code
      t.datetime            :time
      t.decimal             :depth,         :precision => 8, :scale => 4
      t.point               :location,      :geographic => true, :srid => 4326, :has_m => true, :has_z => true, :spatial => true
      t.datetime            :created_at
    end

    create_table(:conditions) do |t|
      t.decimal             :value,         :precision => 12, :scale => 4
      t.string              :unit
      t.string              :name
      t.integer             :hit_id
    end

  end
end
