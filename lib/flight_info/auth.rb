module Auth
  @@config ||= YAML.load_file("#{Dir.pwd}/config/flight.yml")
  @@config['defaults'].each do |key, value|
    instance_variable_set("@#{key}", value)
    self.class.send(:attr_reader, key.to_sym)
  end
end
