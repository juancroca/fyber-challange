module Fyber
  class Client
    attr_reader :errors
    def initialize(api_key)
      raise ArgumentError, "api key must be a valid string" if !api_key.is_a?(String) || api_key.empty?
      @errors = {}
      @api_key = api_key
      @connection = Faraday.new(url: 'http://api.fyber.com') do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    def get_offers(params={})
      errors = [:uid, :appid, :format, :locale].inject({}) do |errors, param|
        errors[param] = 'is required'  if !params.has_key?(param) && !params.has_key?(param.to_s)
        errors
      end
      @errors[:argument] = errors and return unless errors.empty?

      params.merge!(get_hashkey(params))
      response = @connection.get('/feed/v1/offers.json', params)
      body = JSON.parse(response.body)
      if(response.status != 200)
        @errors = body and return
      else
        return body['offers']
      end
    end

    private
    attr_accessor :connection, :api_key
    attr_writer :errors
    def get_hashkey(params={})
      timestamp = Time.now.to_i
      query = params.merge({timestamp: timestamp}).map{|key, value| "#{key}=#{value}"}.join('&') + "&#{@api_key}"
      hashkey = Digest::SHA1.hexdigest query
      {hashkey: hashkey, timestamp: timestamp}
    end
  end
end
