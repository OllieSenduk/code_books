# All service objects should follow the same pattern:

# 1. Has an initialization method with a params argument.
# 2. Has a single public method named call.
# 3. Returns an OpenStruct with a success? and either a payload or an error.

# What’s an OpenStruct?

# It’s like the brainchild of a class and a hash.
# You can think of it as a mini-class that can receive arbitrary attributes.
# In our case, we’re using it as a sort of temporary data structure that handles
# just two attributes.


AppServices::AppSignalApiService.new({endpoint: 'markers'}).call

module AppServices
  class AppSignalApiService
    require 'httparty'

    def initialize(params)
      @endpoint = params[:endpoint] || 'markers'
    end

    def call
      result = HTTParty.get("https://appsignal.com/api/#{appsignal_app_id}/#{@endpoint}.json?token=#{appsignal_api_key}")
    rescue HTTParty::Error => e
      OpenStruct.new({ success?: false, error: e })
    else
      OpenStruct.new({ success?: true, payload: result })
    end

    private

    def appsignal_app_id
      ENV['APPSIGNAL_APP_ID']
    end

    def appsignal_api_key
      ENV['APPSIGNAL_API_KEY']
    end
  end
end
