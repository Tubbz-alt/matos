class SpatialInput < Formtastic::Inputs::StringInput
  def value
    val = object.send(method)
    val if val.nil?
    val.to_s
  end

  def input_html_options
    {
      :value => value
    }.merge(super)
  end

end