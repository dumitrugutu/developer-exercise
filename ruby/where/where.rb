class Array
  def where(query)
    keys = query.keys
    key1 = keys[0]
    class_type = query[key1].class
    key2 = ''

    # check for multiple criteria
    if keys.length > 1
      key2 = keys[1]
    end

    if class_type == String && keys.length == 1
      self.select { |item| item[key1] == query[key1] }
    elsif class_type == Fixnum && keys.length == 1
      self.select { |item| item[key1] == query[key1] }
    elsif class_type == Regexp && keys.length == 1
      self.select { |item| query[key1] =~ item[key1] }
    else
      self.select { |item| item[key1] == query[key1] && item[key2] =~ query[key2] }
    end
  end
end
