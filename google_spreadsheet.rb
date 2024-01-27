require 'json'
require 'net/http'
require 'uri'
require 'pry'

class GoogleSpreadsheetHandler
  def initialize
    @spreadsheet_key = ENV.fetch('GOOGLE_SPREADSHEET_KEY')
    @api_key = ENV.fetch('GOOGLE_SPREADSHEET_API_KEY')
    @sheet_id = ENV.fetch('GOOGLE_SPREADSHEET_SHEET_ID')
  end

  def all
    range = "'#{@sheet_id}'!A:A"
    values = get_values(range)
    values.flatten.compact
  end

  private

  def get_values(range)
    uri = build_uri(range)
    puts uri
    response = make_request(uri)
    puts response.body

    JSON.parse(response.body)['values'] || []
  end

  def build_uri(range)
    base_url = "https://sheets.googleapis.com/v4/spreadsheets/#{@spreadsheet_key}/values/#{range}"
    URI.parse("#{base_url}?key=#{@api_key}")
  end

  def make_request(uri, method = 'get', data = nil)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    case method.downcase
      when 'get'
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'put'
        request = Net::HTTP::Put.new(uri.request_uri, { 'Content-Type' => 'application/json' })
        request.body = data
      else
        raise "Unsupported HTTP method: #{method}"
    end

    http.request(request)
  end
end

puts GoogleSpreadsheetHandler.new.all
