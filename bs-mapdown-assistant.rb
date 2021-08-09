#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#Set 'EXE_DIR' directly at runtime  直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)
#Predefined Constants  設定済み定数
#EXE_DIR ****** Folder with EXE files[It ends with '\']  EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ****** Main ruby script file name  メインのrubyスクリプトファイル名
#ERR_LOG ****** Error log file name  エラーログファイル名

require 'win32ole'
require 'json'

#定数
CURL_TIMEOUT             = 10
BEATSAVER_API_KEY_URL = "https://beatsaver.com/api/maps/id/"
PLAYLIST_FILE            = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\Playlists\\TestPlayList.bplist"
MOD_ASSISTANT            = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\ModAssistant.exe"

#beatsaver key取得
ARGV[1] =~ /\/([0-9a-f]+)\//i
key = $1

#beatsaver 情報取得
hash = nil
begin
  beatsaver_data = JSON.parse(`curl.exe --connect-timeout #{CURL_TIMEOUT} #{BEATSAVER_API_KEY_URL}#{key}`)
  songName = beatsaver_data['metadata']['songName']
  last_version     = beatsaver_data['versions'].last
  hash = last_version['hash'].upcase if last_version
rescue
  puts "BeatSaber ERROR."
  puts "Download without adding to the playlist."
  sleep 1.5
end

if hash
  #プレイリスト更新
  if File.exist?(PLAYLIST_FILE)
    playlist = JSON.parse(File.read(PLAYLIST_FILE))
  else
    playlist = {}
    playlist['playlistTitle'] = "bs-mapdown-assistant"
    playlist['playlistDescription'] = ""
    playlist['playlistAuthor'] = ""
    playlist['image'] = '1'
    playlist['songs'] = []
  end
  song_add = true
  updete_idx = nil
  playlist['songs'].each_with_index do |song_data,idx|
    if song_data['hash'].upcase == hash
      song_add = false
      updete_idx = idx
      break
    end
  end
  if song_add
    puts "Added \"#{songName}\" to PlayList \"#{playlist['playlistTitle']}\""
    sleep 0.8
    song_add_data = {}
    song_add_data['songName'] = songName
    song_add_data['key'] = key
    song_add_data['hash'] = hash
    playlist['songs'].push song_add_data
  else
    update_songs = playlist['songs'][updete_idx]
    playlist['songs'][updete_idx,1] = []
    playlist['songs'].push update_songs
  end
  File.open(PLAYLIST_FILE,'w') do |file|
    JSON.pretty_generate(playlist).each do |line|
      file.puts line
    end
  end
end

command = %!"#{MOD_ASSISTANT}" "#{ARGV[0]}" "#{ARGV[1]}"!

begin
  #外部プログラム呼び出しで、処理待ちしないためWSHのRunを使う
  winshell  = WIN32OLE.new("WScript.Shell")
  winshell.Run(command)
rescue Exception => e
  puts e.inspect
  puts "Press enter to finish."
  STDIN.gets
  exit
end
