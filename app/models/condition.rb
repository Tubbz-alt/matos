class Condition < ActiveRecord::Base

  belongs_to :hit

end

# ## Schema Information
#
# Table name: `conditions`
#
# ### Columns
#
# Name          | Type               | Attributes
# ------------- | ------------------ | ---------------------------
# **`id`**      | `integer`          | `not null, primary key`
# **`value`**   | `decimal(12, 4)`   |
# **`unit`**    | `string(255)`      |
# **`name`**    | `string(255)`      |
# **`hit_id`**  | `integer`          |
#

