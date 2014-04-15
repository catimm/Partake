collection @package_instances, :root => false, :object_root => false
attributes :id, :price, :min_people, :max_people, :advance_notice
attributes :available_start_time, :available_end_time
glue :package do
  attribute :description
  attribute :package_type => :type
  glue :venue do
    node :venue do |v|
      {
        :id => v.id,
        :name => v.name,
        :neighborhood => v.neighborhood
      }
    end
  end
end
