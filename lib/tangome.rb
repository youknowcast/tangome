require_relative '../lib/tangome/dictionary'

dictionary = Dictionary.new

if ARGV.length > 0
  if ARGV[0] == 'dic'
    puts dictionary.dictionary_path
  elsif ARGV[0] == 'all'
    dictionary.list_all
  else
    dictionary.search(ARGV[0])
  end
end
