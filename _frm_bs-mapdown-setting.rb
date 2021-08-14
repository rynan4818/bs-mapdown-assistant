##__BEGIN_OF_FORMDESIGNER__
## CAUTION!! ## This code was automagically ;-) created by FormDesigner.
## NEVER modify manualy -- otherwise, you'll have a terrible experience.

require 'vr/vruby'
require 'vr/vrcontrol'

class Form_main < VRForm

  def construct
    self.caption = 'bs-mapdown-assistant setting'
    self.move(300,100,810,498)
    addControl(VRButton,'button_cancel',"CANCEL",520,400,112,32)
    addControl(VRButton,'button_copy_key',"Clipboard COPY",608,352,152,24)
    addControl(VRButton,'button_copy_path',"Clipboard COPY",536,280,168,24)
    addControl(VRButton,'button_modassistant',"OPEN",656,208,104,24)
    addControl(VRButton,'button_ok',"OK",664,400,104,32)
    addControl(VRButton,'button_playlist',"OPEN",656,80,104,24)
    addControl(VRButton,'button_wip_playlist',"OPEN",656,144,104,24)
    addControl(VREdit,'edit_modassistant',"",48,184,712,24)
    addControl(VREdit,'edit_playlist',"",48,56,712,24)
    addControl(VREdit,'edit_registry_path',"",96,280,440,24,0x800)
    addControl(VREdit,'edit_registry_reg_sz',"",96,328,664,24,0x800)
    addControl(VREdit,'edit_wip_playlist',"",48,120,712,24)
    addControl(VRStatic,'static1',"PlayList",48,32,224,24)
    addControl(VRStatic,'static2',"ModAssistant PATH",48,160,304,24)
    addControl(VRStatic,'static3',"Registry setting",48,240,112,24)
    addControl(VRStatic,'static4',"PATH",56,280,40,24)
    addControl(VRStatic,'static5',"REG_SZ",40,328,56,24)
    addControl(VRStatic,'static6',"WIP Playlist",48,96,112,24)
  end 

end

##__END_OF_FORMDESIGNER__
