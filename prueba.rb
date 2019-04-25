require 'uri'
require 'net/http'
require 'openssl'
require 'json'

def request(address,api_key = "6zo0tclgMkMRycea2qdLnc7GpfnYeBWukw3LNjW0")

  url = URI("#{address}&api_key=#{api_key}")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["Postman-Token"] = 'e6fab5cc-d204-4bb8-aef8-e300b9215e6c'

  response = http.request(request)
  JSON.parse response.read_body
end

body = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10")

def buid_web_page(data)
    photos = data["photos"].map{|x| x['img_src']}
    html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
    photos.each do |photo|
    html += "<li><img src=\"#{photo}\"></li>\n"
  end
    html += "</ul>\n</body>\n</html>\n"
    File.write('output.html', html)
end

buid_web_page(body)

def photos_count(body)
  body['photos'].map{|x| x['camera']['name']}.group_by{|x| x}.map{|k,v| [k,v.count]}
end

puts photos_count(body)
