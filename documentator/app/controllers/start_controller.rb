
class StartController < ApplicationController
	def initialize
		super
		@client_id = "06fb8e1425424f9c1392"
		@client_secret = "b32a8dec19e791579bc0be463dbb3f63ed545e56"
		@access_token = nil
	end
	

	def login
		code = params[:code]
		
		authorize_url = "https://github.com/login/oauth/access_token"
		#added the block at the end so that we can handle the response code ourselves
		begin
			result = RestClient.post(authorize_url, 
				{:client_id => @client_id,
				:client_secret => @client_secret,
				:code => code},
				:accept => "application/json")

			@access_token = JSON.parse(result)['access_token']
			session[:access_token] = @access_token

			#get the username and avatar photo url
			user_info = JSON.parse(RestClient.get("https://api.github.com/user", { :params => {:access_token => @access_token}}))
			session[:user_id] = user_info['id']
			session[:name] = user_info['name']
			session[:photo] = user_info['avatar_url']
			redirect_to "/search"
		rescue RestClient::ExceptionWithResponse => err
			case err.response.code
				when 401
					reset_session
					render file: Dir.pwd() + "/app/views/401.erb.html"
				when 500
					reset_session
					render file: Dir.pwd() + "/app/views/500.erb.html"
			end
		end
		
	end





end
