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
require 'date'

#定数
CURL_TIMEOUT             = 10
BEATSAVER_API_KEY_URL = "https://beatsaver.com/api/maps/id/"
PLAYLIST_FILE            = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\Playlists\\TestPlayList.bplist"
WIP_PLAYLIST_FILE        = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\Playlists\\WipTestPlayList.bplist"
MOD_ASSISTANT            = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Beat Saber\\ModAssistant.exe"
UNSHIFT                  = false

#beatsaver key取得
ARGV[1] =~ /\/([0-9a-f]+)\//i
key = $1
wip_flag = false

#beatsaver 情報取得
begin
  beatsaver_data = JSON.parse(`curl.exe --connect-timeout #{CURL_TIMEOUT} #{BEATSAVER_API_KEY_URL}#{key}`)
  songName = beatsaver_data['metadata']['songName']
  versions = beatsaver_data['versions']
  if versions.size == 0
    hash = nil
  else
    sort_versions = versions.sort {|a, b| DateTime.parse(b['createdAt']) <=> DateTime.parse(a['createdAt'])}
    hash = sort_versions[0]['hash'].upcase
    wip_flag = true unless sort_versions[0]['state'] == 'Published'
  end
rescue
  puts "BeatSaber ERROR."
  puts "Download without adding to the playlist."
  sleep 1.5
end

if hash
  #プレイリスト更新
  if wip_flag
    playlist_file = WIP_PLAYLIST_FILE
  else
    playlist_file = PLAYLIST_FILE
  end
  if File.exist?(playlist_file)
    playlist = JSON.parse(File.read(playlist_file))
  else
    playlist = {}
    if wip_flag
      playlist['playlistTitle'] = "WIP-bs-mapdown-assistant"
    else
      playlist['playlistTitle'] = "bs-mapdown-assistant"
    end
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
    if UNSHIFT
      playlist['songs'].unshift song_add_data
    else
      playlist['songs'].push song_add_data
    end
  else
    update_songs = playlist['songs'][updete_idx]
    playlist['songs'][updete_idx,1] = []
    if UNSHIFT
      playlist['songs'].unshift update_songs
    else
      playlist['songs'].push update_songs
    end
  end
  File.open(playlist_file,'w') do |file|
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
