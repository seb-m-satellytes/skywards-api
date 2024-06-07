class XpPoint < ApplicationRecord
  belongs_to :xpable, polymorphic: true
end

# 
