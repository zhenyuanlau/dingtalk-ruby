require "dingtalk/version"
require "dingtalk/api/base"
require 'pry'

# Dingtalk top namespace
module Dingtalk
  class Error < StandardError; end
  class RequestException < RuntimeError; end

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Dingtalk::Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
  
  class Configuration
    attr_accessor :oapi_host, :corpid, :appkey, :appsecret

    def initialize
      @oapi_host = "https://oapi.dingtalk.com"
      @corpid = ""
      @appkey = ""
      @appsecret = ""
    end
  end

  class Client
    
  end

  P_APPKEY = "app_key".freeze
  P_API = "method".freeze
  P_ACCESS_TOKEN = "access_token".freeze
  P_VERSION = "v".freeze
  P_FORMAT = "format".freeze
  P_TIMESTAMP = "timestamp".freeze
  P_SIGN = "sign".freeze
  P_SIGN_METHOD = "sign_method".freeze
  P_PARTNER_ID = "partner_id".freeze

  SYSTEM_GENERATE_VERSION = "taobao-sdk-ruby-dynamicVersionNo".freeze

  P_CODE = 'errcode'.freeze
  P_MSG = 'errmsg'.freeze

  module Api
    autoload :OapiGettokenRequest, 'dingtalk/api/OapiGettokenRequest'
    autoload :OapiSnsGetuserinfoBycodeRequest, 'dingtalk/api/OapiSnsGetuserinfoBycodeRequest'
    autoload :OapiUserGetUseridByUnionidRequest, 'dingtalk/api/OapiUserGetUseridByUnionidRequest'
    autoload :OapiUserGetRequest, 'dingtalk/api/OapiUserGetRequest'
  end
end
