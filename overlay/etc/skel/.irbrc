if RUBY_VERSION < '1.9'
  $KCODE='u'
  require 'jcode'
end
require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history" 
IRB.conf[:PROMPT_MODE] = :SIMPLE
