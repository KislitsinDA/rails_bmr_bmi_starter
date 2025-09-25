require 'net/http'
require 'json'
class ExternalBmiService
  def self.fetch(height_cm, weight_kg)
    raise ArgumentError, "height and weight required" unless height_cm && weight_kg
    height_m = height_cm.to_f / 100.0
    # Fallback local BMI calc if API is unreachable
    local_bmi = (weight_kg.to_f / (height_m ** 2)).round(2) rescue nil

    uri = URI("https://www.freepublicapis.com/bmi-calculator-api")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    path = uri.request_uri + "?height=#{height_cm}&weight=#{weight_kg}"
    req = Net::HTTP::Get.new(path)
    begin
      res = http.request(req)
      if res.code.to_i == 200
        data = JSON.parse(res.body) rescue {}
        return { bmi_api: data, bmi_local: local_bmi }
      end
    rescue => e
      # ignore, fallback to local
    end
    { bmi_api: { error: "api_unavailable" }, bmi_local: local_bmi }
  end
end
