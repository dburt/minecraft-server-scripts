#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

def heading(h, underline = "=")
  "#{h}\n#{underline * h.length}\n"
end

get '/' do
  redirect '/today'
end

get '/today' do
  content_type "text/plain"

  heading("Today") + 
  File.read("logs/latest.log")
end

get '/yesterday' do
  older_files = Dir.glob("logs/*.log.gz")
  most_recent = older_files.sort.last

  content_type "text/plain"

  heading("Yesterday") + 
    `gunzip -c '#{most_recent}'`
end

get "/advancements" do
  content_type "text/plain"

  heading("Advancements") +
    File.read("logs/latest.log").lines.grep(/advancement/).join
end

get "/chat" do
  content_type "text/plain"

  heading("Chat") +
    File.read("logs/latest.log").lines.grep(/<.*>/).join
end