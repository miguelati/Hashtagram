# encoding: UTF-8

require "sinatra"
require "instagram"
require "sequel"
require "./lib/config"

enable :sessions
set :public_folder, 'public'

SERVER = "http://localhost:4567"
CALLBACK_URL = SERVER + "/oauth/callback"
HASHTAG = "millercalvinharris"

Instagram.configure do |config|
  config.client_id = "139d1d0c9e70452998977581fdc9b5dd"
  config.client_secret = "9f9610a9a09c4db6bfcb33ecfcedad05"
end

Hashtagram.config

get "/login" do
  '<a href="/oauth/connect">Conectate con tu cuenta de Instagram</a>'
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/feed"
end

get "/feed" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user
	
	session[:last] = 0 if session[:last] == nil
	data_tags = client.tag_recent_media(HASHTAG,{max_id: session[:last]})
	session[:last] = data_tags.pagination.next_max_tag_id if data_tags.pagination.next_max_tag_id != nil
	
	#new_posts = Hashtagram.add(data_tags['data'])
	
  html = "<h1>User: #{user.username} - #{user.id} - #{session[:last]}</h1>"
  html << "Total de hashtags insertados: #{data_tags["data"].inspect}"
	
	#erb :feed, locals: {username: user.username, instagram_id: user.id, last_id: session[:last], new_posts: new_posts, server: SERVER}
end

get "/" do
	erb :index, locals: {server: SERVER}
end

get "/resetdb" do
	Hashtagram.reset_db
	"La base de datos esta limpia"
end

get "/hashtag/:tag" do
	HASHTAG = params[:tag]
	"Ya se cambió el hashtag"
end

get "/change_post.js" do
	row = Hashtagram.get_one
	if row.count > 0
		erb :'change_post.js', locals: {post: row[0], server: SERVER}
	else
		erb :'change_post.js', locals: {post: nil, server: SERVER}
	end
	
end

get "/aprobar/:id" do
	Hashtagram.acept(params[:id])
	erb :'aprobar.js', locals: {post_id: params[:id]}
end