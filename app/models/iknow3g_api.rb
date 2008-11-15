class Iknow3gApi
  class InvalidResultError < StandardError; end

  class <<self
    API_KEY = ''
    API_URI_BASE = "http://api.iknow.co.jp"
  
    def user_profile(username)
      call_api "users/#{username}", 'profile'
    end
  
    def study_results(username, type='iknow')
      call_api("users/#{username}/study_results/#{type}", 'study_results', :per_page => 1).first
    end
  
    def items_studied(username, opts)
      call_api "users/#{username}/items", nil, {:per_page => 50}.update(opts)
    end

    def search_sentences(keyword)
      call_api "sentences/matching/#{keyword}"
    end
  
    protected
  
    def call_api(api_type, result_key=nil, opts={})
      uri = "#{API_URI_BASE}/#{api_type}.json?api_key=#{API_KEY}&#{opts.to_a.map{|(k, v)| "#{k}=#{v}"}.join '&'}"
      hash = JSON.parse open(uri){|f| f.read}
      if result_key
        hash[result_key.to_s]
      else
        hash
      end
    end
  end
end

