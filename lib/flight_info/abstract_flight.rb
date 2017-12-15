require 'logger'
require 'HTTParty'
require 'yaml'
require 'pry'

module AbstractFlight
  include HTTParty
  def query(method_name, args)
    post(method_name, headers: body_content(args), body: build_query(args).to_json, format: :json)
  end

  def translateFlight(hash, translate)
    new_hash = Marshal.load(Marshal.dump(hash))
    hash.each do |key, _value|
      translateFlight(hash[key], translate) if hash[key].is_a? Hash
      new_hash[translate[key]] = new_hash.delete key
    end
    hash = new_hash
  end
  logger ::Logger.new("#{Dir.pwd}/tmp/httparty.log"), :debug, :curl
end
