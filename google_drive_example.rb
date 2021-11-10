require "sinatra"
require "http"
require "dotenv"

Dotenv.load

enable :sessions

CLIENT_ID = ENV["CLIENT_ID"]
CLIENT_SECRET = ENV["CLIENT_SECRET"]

SCOPE = 'https://www.googleapis.com/auth/drive.metadata.readonly'.freeze
GOOGLE_AUTH_URI = 'https://accounts.google.com/o/oauth2/v2/auth'.freeze
GOOGLE_TOKEN_URI = 'https://oauth2.googleapis.com/token'.freeze
GOOGLE_DRIVES_FILES = 'https://www.googleapis.com/drive/v2/files'.freeze

REDIRECT_URI = 'http://localhost:4567/oauth2callback'.freeze

google_authorization_url = "#{GOOGLE_AUTH_URI}?response_type=code&client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URI}&scope=#{SCOPE}"

file_list_erb_template = %(
  <a href="/">Back</a>
  <h1>Files:</h1>
  <ol>
    <% @items.each do |item| %>
      <li><%= item["title"] %></li>
    <% end %>
  </ol>
)

home_erb_template = %(
  <h1>Google Drive API demo using OAuth2 authorization</h1>
  <a href='#{google_authorization_url}'>Log in to Google Drive</a>
)

get "/" do
  erb home_erb_template
end

get "/oauth2callback" do
  response = HTTP.headers(accept: 'application/json').post(
    GOOGLE_TOKEN_URI,
    form: {
      code: params[:code],
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      redirect_uri: REDIRECT_URI,
      grant_type: 'authorization_code'
    }
  )

  session[:access_token] = response.parse["access_token"]
  redirect to "/list"
end

get "/list" do
  access_token = session[:access_token]
  
  response = HTTP
    .headers(accept: 'application/json', Authorization: "Bearer #{access_token}")
    .get(GOOGLE_DRIVES_FILES)

  @items = response.parse['items']
  erb file_list_erb_template
end