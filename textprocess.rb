require 'vr/vruby'
require 'vr/vrcontrol'
require 'vr/vrcomctl'
require 'vr/vrlayout2'
require 'vr/vrmargin'
require 'vr/vrddrop'

class FileListView < VRListview
  def vrinit
    super
    addColumn('name', 300)
  end

  def addFile file
    addItem([file])
  end
end

MIN_WIDTH  = 450
MIN_HEIGHT = 300


module TextProcForm
  include VRResizeable
  include VRDropFileTarget

  BTN_WIDTH = 120
  BTN_HEIGHT = 24

  def construct
    self.caption = "TextProccessor"

    add(VRButton, 'exec',   'Execute!', WStyle::WS_BORDER)
    add(VRButton, 'clear',  'Clear')
    add(VRButton, 'cancel', 'Cancel')

    add(VRRadiobutton, 'rbt1', 'in place')
    add(VRRadiobutton, 'rbt2', 'suffix')
    @rbt1.check true

    add(FileListView, 'filelist', 'lv')
  end

  def add klass, name, caption, style=0
    addControl(klass, name, caption, 0, 0, 0, 0, style)
  end



  def self_resize w, h
    if w < MIN_WIDTH
      w = MIN_WIDTH
    end
    if h < MIN_HEIGHT
      h = MIN_HEIGHT
    end

    @exec.move(  w-(10+BTN_WIDTH)*3, h-(10+BTN_HEIGHT), BTN_WIDTH, BTN_HEIGHT)
    @clear.move( w-(10+BTN_WIDTH)*2, h-(10+BTN_HEIGHT), BTN_WIDTH, BTN_HEIGHT)
    @cancel.move(w-(10+BTN_WIDTH),   h-(10+BTN_HEIGHT), BTN_WIDTH, BTN_HEIGHT)

    @rbt1.move(10, 10, 250, 20)
    @rbt2.move(10, 40, 250, 20)

    @filelist.move(10, 70, w-20, h-70-20-BTN_HEIGHT)
  end

  def self_dropfiles files
    files.each do |file|
      @filelist.addFile(file)
    end
  end

  def cancel_clicked
    close
  end
end

VRLocalScreen.showForm(TextProcForm, 100, 100, MIN_WIDTH, MIN_HEIGHT)
VRLocalScreen.messageloop
