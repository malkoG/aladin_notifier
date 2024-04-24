class Metric < ApplicationRecord
  belongs_to :target, polymorphic: true

  def increase_amount!
    transaction do 
      increment!(:amount)
    end
  end
end
