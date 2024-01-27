require 'open-uri'
require 'nokogiri'
require 'toml-rb'

class Class単語辞書
  CONST_辞書ファイル = File.expand_path('../../辞書.toml', __dir__).freeze

  def initialize
    @辞書 = 読込
  end

  attr_accessor :辞書

  def initialize
    @辞書 = 読込
  end

  attr_accessor :辞書

  # editor で開く用に辞書ファイルのパスを返します
  def 直接編集
    CONST_辞書ファイル
  end

  def 読込
    begin
      TomlRB.load_file(CONST_辞書ファイル)
    rescue Errno::ENOENT
      File.new(CONST_辞書ファイル, 'w')
      TomlRB.load_file(CONST_辞書ファイル)
    end
  end

  def 検索(単語)
    辞書.keys.find { _1 == 単語 }
  end

  def 一覧
    辞書.each do |単語, 説明|
      表示(単語)
    end
  end

  def 追加(単語, 説明 = nil)
    unless 説明
      説明 = Webで検索(単語)
      説明 = 'TBD' if 説明.empty?
    end
    辞書[単語] = 説明
    File.open('辞書.toml', 'w+') { |file| file.write(TomlRB.dump(辞書)) }

    表示(単語)
  end

  def 表示(単語)
    puts 単語 ? "#{単語}: #{辞書[単語]}" : '単語が見つかりません'
  end

  private

  def Webで検索(単語)
    url = "https://ejje.weblio.jp/content/#{URI.encode_www_form_component(単語)}"
    doc = Nokogiri::HTML(URI.open(url), nil, 'utf-8')
    text = doc.at_css('#summary .content-explanation')&.text
    text&.strip || ''
  rescue OpenURI::HTTPError
    ''
  end
end