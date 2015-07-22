# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'rack'
require 'rack/server'


Fringe::Server.initialize(File.dirname(__FILE__))

run Fringe::Server
