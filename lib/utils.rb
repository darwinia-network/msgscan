def timed
  b = Time.now
  yield
  e = Time.now
  Rails.logger.debug "#{e - b}s"
end

def snake_case(str)
  str.gsub(/::/, '/')
     .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
     .gsub(/([a-z\d])([A-Z])/, '\1_\2')
     .tr('-', '_')
     .downcase
end

def to_camel(str)
  if str.include?('_')
    splits = str.split('_')
    splits[0] + splits[1..].collect(&:capitalize).join
  else
    str[0].downcase + str[1..]
  end
end

def to_pascal(str)
  str.split('_').collect(&:capitalize).join
end
