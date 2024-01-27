require_relative '../lib/tangome/単語辞書'

辞書 = Class単語辞書.new

if ARGV.length > 0
  if ARGV[0] == 'add' && !ARGV[1].nil?
    結果 = 辞書.検索(ARGV[1])
    if 結果.is_a?(String)
      puts 'すでに登録されています'
      辞書.表示(結果)
      return
    end

    辞書.追加(ARGV[1])
  elsif ARGV[0] == 'dic'
    puts 辞書.直接編集
  else
    単語 = 辞書.検索(ARGV[0])
    辞書.表示(単語)
  end
else
  辞書.一覧
end