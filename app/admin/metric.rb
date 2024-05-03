ActiveAdmin.register Metric do
  index do
    column :target_id
    column :target_type
    column :metric_type
    column :resource
    column :amount
    column :date
  end
end
