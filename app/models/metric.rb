class Metric < ApplicationRecord
  belongs_to :target, polymorphic: true
end
