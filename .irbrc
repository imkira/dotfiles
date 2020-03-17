#!/usr/bin/env ruby

require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:AUTO_INDENT]=true
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:USE_MULTILINE] = true

require 'rubygems'

require 'wirble'
Wirble.init
Wirble.colorize

require 'map_by_method'
require 'what_methods'

require 'pp'
