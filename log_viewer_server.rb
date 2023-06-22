#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

get '/' do
  "Hi there, I hope you are having a good day."
end

get '/today' do
  headers "Content-Type" => "text/plain"
  File.read("logs/latest.log")
end

get '/yesterday' do
  older_files = Dir.glob("logs/*.log.gz")
  most_recent = older_files.sort.last

  headers "Content-Type" => "text/plain"
  `gunzip -c '#{most_recent}'`
end

