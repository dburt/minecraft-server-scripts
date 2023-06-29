#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'pathname'

def heading(h, underline = "=")
  "#{h}\n#{underline * h.length}\n"
end

def logs_dir
  Pathname("../logs")
end

def log_lines
  (logs_dir + "latest.log").read.lines
  # TODO: read all the files
end

get '/' do
  redirect '/today'
end

get '/today' do
  content_type "text/plain"

  heading("Today") + 
    (logs_dir + "latest.log").read
end

get '/yesterday' do
  older_files = logs_dir.glob("*.log.gz")
  most_recent = older_files.sort.last

  content_type "text/plain"

  heading("Yesterday") + 
    `gunzip -c '#{most_recent}'`
end

get "/advancements" do
  content_type "text/plain"

  heading("Advancements") +
    log_lines.grep(/advancement/).join
end

get "/chat" do
  content_type "text/plain"

  heading("Chat") +
    log_lines.grep(/<.*> /).join
end

get "/joins_and_exits" do
  content_type "text/plain"

  heading("Joins and Exits") +
    log_lines.grep(/(joined|left) the game/).join
end

# TODO: categories for advancements, chat, commands, joins, exits, server start/stop
# TODO: filter logs by date, category, string
