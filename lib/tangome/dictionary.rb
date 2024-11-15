require 'open-uri'
require 'nokogiri'
require 'toml-rb'

class Dictionary
  CONST_DICTIONARY_PATH = File.expand_path('../../dictionary.toml', __dir__ || __FILE__).freeze

  def initialize
    @dictionary = load_dictionary
  end

  attr_accessor :dictionary

  # editor で開く用に辞書ファイルのパスを返します
  def dictionary_path
    CONST_DICTIONARY_PATH
  end

  def search(word)
    result = search_local(word)
    if result && result.is_a?(String)
      show(word)
      return
    end

    result = search_weblio(word)
    unless result.empty?
      add(word, result)
      show(word)
      return
    end

    show('')
    add_custom_word_or_nothing(word)
  end

  def list_all
    dictionary.each do |word, explain|
      show(word)
    end
  end

  def add(word, explain = nil)
    unless explain
      explain = search_weblio(word)
      explain = 'TBD' if explain.empty?
    end
    dictionary[word] = explain

    save_dictionary
  end

  def add_custom_word_or_nothing(word)
    puts "単語を登録しますか？(y/n)"
    answer = STDIN.gets&.chomp
    if answer.downcase == 'y'
      explain = STDIN.gets
      if explain != ''
        add(word, explain)
        show(word)
      end
    end
  end

  def show(word)
    explain = dictionary[word]
    if explain.nil?
      puts "単語が見つかりません．"
    elsif word.is_a?(String)
      puts "#{word}: #{dictionary[word]}"
    else
      puts "候補が見つかりました(先頭から 5 件表示します)"
      word.take(5).each do |w|
        puts "#{w}: #{dictionary[w]}"
      end
    end
  end

  private

  def load_dictionary
    begin
      TomlRB.load_file(CONST_DICTIONARY_PATH)
    rescue Errno::ENOENT
      File.new(CONST_DICTIONARY_PATH, 'w')
      TomlRB.load_file(CONST_DICTIONARY_PATH)
    end
  end

  def save_dictionary
    File.open(CONST_DICTIONARY_PATH, 'w+') { |file| file.write(TomlRB.dump(dictionary)) }
  end

  def search_local(word)
    result = dictionary.keys.find { _1 == word }
    result ||= dictionary.keys.filter { _1.include?(word) }
    result || ''
  end

  def search_weblio(word)
    url = "https://ejje.weblio.jp/content/#{URI.encode_www_form_component(word)}"
    doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
    text = doc.at_css('#summary .content-explanation')&.text
    text&.strip || ''
  rescue OpenURI::HTTPError
    ''
  end
end