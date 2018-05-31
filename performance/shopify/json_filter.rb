module JsonFilter
  def json(object)
    object.reject {|k,v| k == "collections" }.to_json
  end

  def custom_json(object, *fields)
    if object.is_a? Array
      drop = object.first
      fields = drop.respond_to?(:json_fields) ? drop.json_fields & fields : []
      object.map do |item|
        fields.each_with_object({}) { |opt, hash| hash[opt] = item.public_send(opt) }
      end.to_json
    else
      fields = object.respond_to?(:json_fields) ? object.json_fields & fields : []
      fields.each_with_object({}) { |opt, hash| hash[opt] = object.public_send(opt) }.to_json
    end
  end
end
