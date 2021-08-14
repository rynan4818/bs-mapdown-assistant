#! ruby -Ks
# -*- mode:ruby; coding:shift_jis -*-
$KCODE='s'

#Set 'EXE_DIR' directly at runtime  直接実行時にEXE_DIRを設定する
EXE_DIR = (File.dirname(File.expand_path($0)).sub(/\/$/,'') + '/').gsub(/\//,'\\') unless defined?(EXE_DIR)

#Available Libraries  使用可能ライブラリ
#require 'jcode'
#require 'nkf'
#require 'csv'
#require 'fileutils'
#require 'pp'
#require 'date'
#require 'time'
#require 'base64'
#require 'win32ole'
#require 'Win32API'
#require 'vr/vruby'
#require 'vr/vrcontrol'
#require 'vr/vrcomctl'
#require 'vr/clipboard'
#require 'vr/vrddrop.rb'
#require 'json'

#Predefined Constants  設定済み定数
#EXE_DIR ****** Folder with EXE files[It ends with '\']  EXEファイルのあるディレクトリ[末尾は\]
#MAIN_RB ****** Main ruby script file name  メインのrubyスクリプトファイル名
#ERR_LOG ****** Error log file name  エラーログファイル名



require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/clipboard'
require '_frm_bs-mapdown-setting'

BS_MAPDOWN_ASSISTANT_SOURCE = EXE_DIR + "bs-mapdown-assistant.rb"

class Form_main                                                     ##__BY_FDVR

  def self_created
    @source_orginal = []
    File.open(BS_MAPDOWN_ASSISTANT_SOURCE) do |source_file|
      while line = source_file.gets
        if defined?(PLAYLIST_FILE) == nil && line.strip =~ /^PLAYLIST_FILE\s*=\s*.+$/
          begin
            eval line
          rescue SyntaxError    #SyntaxErrorのrescueはクラス指定しないと取得できない
            messageBox("Syntax Errorr\n#{line}","PLAYLIST_FILE Setting Syntax ERROR",48)
          rescue => e
            messageBox("#{e.inspect}\r\n#{line}","PLAYLIST_FILE Setting ERROR",48)
          end
          line = "#PLAYLIST_FILE#"
        end
        if defined?(WIP_PLAYLIST_FILE) == nil && line.strip =~ /^WIP_PLAYLIST_FILE\s*=\s*.+$/
          begin
            eval line
          rescue SyntaxError    #SyntaxErrorのrescueはクラス指定しないと取得できない
            messageBox("Syntax Errorr\n#{line}","WIP_PLAYLIST_FILE Setting Syntax ERROR",48)
          rescue => e
            messageBox("#{e.inspect}\r\n#{line}","WIP_PLAYLIST_FILE Setting ERROR",48)
          end
          line = "#WIP_PLAYLIST_FILE#"
        end
        if defined?(MOD_ASSISTANT) == nil && line.strip =~ /^MOD_ASSISTANT\s*=\s*.+$/
          begin
            eval line
          rescue SyntaxError    #SyntaxErrorのrescueはクラス指定しないと取得できない
            messageBox("Syntax Error\r\n#{line}","MOD_ASSISTANT Setting Syntax ERROR",48)
          rescue => e
            messageBox("#{e.inspect}\r\n#{line}","MOD_ASSISTANT Setting ERROR",48)
          end
          line = "#MOD_ASSISTANT#"
        end
        @source_orginal.push line
      end
    end
    @edit_playlist.text = PLAYLIST_FILE if defined? PLAYLIST_FILE
    @edit_wip_playlist.text = WIP_PLAYLIST_FILE if defined? WIP_PLAYLIST_FILE
    @edit_modassistant.text = MOD_ASSISTANT if defined? MOD_ASSISTANT
    @edit_registry_path.text = 'HKEY_CLASSES_ROOT\beatsaver\shell\open\command'
    @edit_registry_reg_sz.text = %Q!"#{EXE_DIR}bs-mapdown-assistant.exe" "--install" "%1"!
  end
  
  def button_playlist_clicked
    if result = open_file("PlayList Select",[["PlayList File (*.bplist)","*.bplist"],["All File (*.*)","*.*"]],"*.bplist",@edit_playlist.text,'MapDown_PlayList.bplist')
      @edit_playlist.text = result
    end
  end

  def button_wip_playlist_clicked
    if result = open_file("WIP PlayList Select",[["PlayList File (*.bplist)","*.bplist"],["All File (*.*)","*.*"]],"*.bplist",@edit_wip_playlist.text,'MapDown_WIP_PlayList.bplist')
      @edit_wip_playlist.text = result
    end
  end

  def button_modassistant_clicked
    if result = open_file("ModAssistant Select",[["exe File (*.exe)","*.exe"],["All File (*.*)","*.*"]],"*.exe",@edit_modassistant.text,'ModAssistant.exe')
      @edit_modassistant.text = result
    end
  end

  def button_copy_path_clicked
    Clipboard.open(self.hWnd) do |cb|
      cb.setText @edit_registry_path.text.strip
    end
  end

  def button_copy_key_clicked
    Clipboard.open(self.hWnd) do |cb|
      cb.setText @edit_registry_reg_sz.text.strip
    end
  end

  def button_cancel_clicked
    close
  end

  def button_ok_clicked
    File.open(BS_MAPDOWN_ASSISTANT_SOURCE,'w') do |source_file|
      @source_orginal.each do |org|
        case org
        when "#PLAYLIST_FILE#"
          source_file.puts %Q!PLAYLIST_FILE            = "#{@edit_playlist.text.gsub(/\\/,'\\\\\\\\')}"!
        when "#WIP_PLAYLIST_FILE#"
          source_file.puts %Q!WIP_PLAYLIST_FILE        = "#{@edit_wip_playlist.text.gsub(/\\/,'\\\\\\\\')}"!
        when "#MOD_ASSISTANT#"
          source_file.puts %Q!MOD_ASSISTANT            = "#{@edit_modassistant.text.gsub(/\\/,'\\\\\\\\')}"!
        else
          source_file.puts org
        end
      end
    end
    close
  end

  def open_file(title,ext_list,default_ext,path = "",default_filename = "")
    folder   = File.dirname(path.to_s.strip)
    folder   = "" unless File.directory?(folder)
    folder   = "" if path == ""
    filename = File.basename(path.to_s.strip)
    filename = default_filename if filename.strip == ''
    filename = SWin::CommonDialog::openFilename(self,ext_list,0x1004,title,default_ext,folder,filename)
    return false unless filename                               #ファイルが選択されなかった場合、キャンセルされた場合は戻る
    return false unless File.exist?(filename)                  #filenameのファイルが存在しなければ戻る
    return filename
  end

end                                                                 ##__BY_FDVR

VRLocalScreen.start Form_main
