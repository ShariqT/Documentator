class SearchController < ApplicationController
	@baseUrl = "http://localhost:3000"
	def index
	end

	def query
		begin
			query = params[:query]
			if params[:page].present?
				page = params[:page]
			else
				page=1
			end
			p params
			response = RestClient.get("https://api.github.com/search/issues?q=documentation+in:title,body+state:open+language:" + query + "&page=" + page.to_s + "&access_token=" + session[:access_token])
			dict_response = JSON.parse(response)
			links = Hash.new
			if response.headers[:link].present?
				p response.headers[:link]
				response.headers[:link].split(",").each do |l|
					
					matches = l.match(/page=(\d+).+; rel=\"(next|last|prev|first)\"/)
					
					links["#{matches[2]}"] = matches[1]
				end
			end
			dict_response['pagination'] = links
			dict_response['items'].each do |r|
				repo_res = RestClient.get(r['repository_url'] + "?access_token=" + session[:access_token])

				if repo_res.code == 200
					repo_res_json = JSON.parse(repo_res)
					r['repo_info'] = repo_res_json
				end
			end
			render json: dict_response
		rescue RestClient::ExceptionWithResponse => err
			puts "there was an error"
			p err
			render json: {:error=> "there was an error fullfilling this request. Please log back in and try again."}
		end
	end


end
