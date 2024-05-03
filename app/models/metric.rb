class Metric < ApplicationRecord
  belongs_to :target, polymorphic: true

  def self.ransackable_attributes(auth_object = nil)
    %w[target_type target_id resource metric_type date amount]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[]
  end

  def increase_amount!
    transaction do 
      increment!(:amount)
    end
  end
end
