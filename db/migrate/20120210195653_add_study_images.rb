class AddStudyImages < ActiveRecord::Migration
  def change
    add_attachment :studies, :img_first
    add_attachment :studies, :img_second
    add_attachment :studies, :img_third
    add_attachment :studies, :img_fourth
    add_attachment :studies, :img_fifth
  end
end
