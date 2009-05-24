#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import gtk
import vte
import newparser #newparser.py
import user

(COL_NUM, COL_TITLE,
 COL_ARTIST, COL_ALBUM,
 COL_SIZE, COL_URL) = range(6)

(COL_FILE_NUM, COL_FILE_NAME, COL_FILE_TITLE, COL_FILE_ARTIST,
 COL_FILE_ALBUM, COL_FILE_SIZE, COL_FILE_PATH) = range(7)

class MainWindow(gtk.Window):
    def __init__(self, parent=None):
        self.downdir = user.home
        self.pageNum = -1
        self.url = ''#第0页的url
        gtk.Window.__init__(self)
        self.connect('destroy', gtk.main_quit)      
        vbox = gtk.VBox()
        vbox.set_border_width(10)
        self.add(vbox)
        
        hbox1 = gtk.HBox()
        self.entry = gtk.Entry()
        self.entry.connect('activate', self.doSearch, None)
        label11 = gtk.Label('关键字：')
        hbox1.pack_start(label11, False)
        hbox1.pack_start(self.entry)
        self.set_focus_child(self.entry)
        button11 = gtk.Button('搜索')
        button11.connect('clicked', self.doSearch, None)
        size = button11.size_request()
        button11.set_size_request(size[0]+50, -1)
        hbox1.pack_start(button11, expand = False)
        vbox.pack_start(hbox1, expand = False)

        hbox = gtk.HBox()
        prepage = gtk.Button('上一页')
        prepage.connect('clicked', self.prepage, None)
        prepage.set_size_request(size[0]+50, -1)
        nextpage = gtk.Button('下一页')
        nextpage.connect('clicked', self.nextpage, None)
        nextpage.set_size_request(size[0]+50, -1)
        self.page = gtk.Entry(5)
        self.page.connect('activate', self.thispage, None)
        self.page.set_size_request(80, -1)
        label = gtk.Label('当前页：')
        hbox.pack_start(label, expand = False)
        hbox.pack_start(self.page, expand = False)
        hbox.pack_end(prepage, expand = False)
        hbox.pack_end(nextpage, expand = False)
        vbox.pack_start(hbox, expand=False)               

        self.notebookup = gtk.Notebook()
        scroll = gtk.ScrolledWindow()
        scroll.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        scroll.set_shadow_type(gtk.SHADOW_ETCHED_IN)
        dirview = self.setDirView()
        dirview.set_rules_hint(True)        
        scroll.add(dirview)
        tvbox = gtk.VBox()
        tvbox.pack_start(scroll)
        hbox = gtk.HBox()
        button = gtk.Button('刷新')
        button.connect('clicked', self.refresh, None)
        size = button.size_request()
        button.set_size_request(size[0]+50, -1)
        hbox.pack_start(button, expand=False)
        self.entryFileDir = gtk.Entry()
        self.entryFileDir.set_text(self.downdir)
        hbox.pack_start(self.entryFileDir)        
        button = gtk.Button('浏览')
        button.connect('clicked', self.setdir, self.entryFileDir)
        size = button.size_request()
        button.set_size_request(size[0]+50, -1)
        hbox.pack_start(button, expand=False)
        expander = gtk.Expander('设置列表目录')
        expander.add(hbox)
        expander.set_expanded(True)
        tvbox.pack_start(expander, expand=False)
        self.notebookup.append_page(tvbox, gtk.Label('文件'))
        scroll = gtk.ScrolledWindow()
        scroll.set_policy(gtk.POLICY_AUTOMATIC, gtk.POLICY_AUTOMATIC)
        scroll.set_shadow_type(gtk.SHADOW_ETCHED_IN)
        tree = self.setTreeView()
        tree.set_rules_hint(True)
        scroll.add(tree)
        self.notebookup.append_page(scroll, gtk.Label('搜索'))        
        

        self.vteListen = vte.Terminal()
        #self.vte.set_font_from_string("sans 10")
        scrollbar = gtk.VScrollbar()
        adjustment = self.vteListen.get_adjustment()
        scrollbar.set_adjustment(adjustment)
        hbox = gtk.HBox()
        hbox.pack_start(self.vteListen)
        hbox.pack_start(scrollbar, expand=False)
        self.vteListen.set_size_request(0, 100)
        #改不了颜色，不解中
        #self.vteListen.set_color_foreground(gtk.gdk.color_parse('#000000'))
        #self.vteListen.set_color_background(gtk.gdk.color_parse('#00ffff'))
        self.vteListen.connect ("child-exited", self.on_vte_exit, None)
        self.vteListen.fork_command('bash')
        self.notebook = gtk.Notebook()
        self.notebook.append_page(hbox, gtk.Label('试听'))
        self.vteDown = vte.Terminal()
        scrollbar = gtk.VScrollbar()
        adjustment = self.vteDown.get_adjustment()
        scrollbar.set_adjustment(adjustment)
        hbox = gtk.HBox()
        hbox.pack_start(self.vteDown)
        hbox.pack_start(scrollbar, expand=False)
        self.vteDown.set_size_request(0, 100)
        self.vteDown.connect ("child-exited", self.on_vte_exit, None)
        self.vteDown.fork_command('bash')
        self.notebook.append_page(hbox, gtk.Label('下载'))

        vpaned = gtk.VPaned()
        vpaned.pack1(self.notebookup, resize = True)
        vpaned.pack2(self.notebook, resize = False)
        vbox.pack_start(vpaned, padding = 10)

        hbox2 = gtk.HBox()
        label21 = gtk.Label('保存目录:')
        self.entry2 = gtk.Entry()
        self.entry2.set_text(self.downdir)
        button21 = gtk.Button('浏览')
        button21.connect('clicked', self.setdir, self.entry2)
        size = button21.size_request()
        button21.set_size_request(size[0]+50, -1)
        hbox2.pack_start(label21, expand=False)
        hbox2.pack_start(self.entry2)
        hbox2.pack_start(button21, expand=False)
        vbox.pack_start(hbox2, expand=False, padding=10)
        self.set_title('mp3下载')
        self.set_default_size(800, 600)
        
        

    def setTreeView(self):
        #依次存入：歌曲编号，歌曲名，歌手，专辑，长度，url
        self.model = gtk.ListStore(str, str, str, str, str, str)
        treeview = gtk.TreeView(self.model)
        treeview.connect('button-press-event', self.onSearchListRightClicked, None)
        treeview.get_selection().set_mode(gtk.SELECTION_SINGLE)
        
        renderer = gtk.CellRendererText()
        renderer.set_data("column", COL_NUM)
        column = gtk.TreeViewColumn("编号", renderer, text=COL_NUM)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data("column", COL_TITLE)
        renderer.set_property('editable', True)
        renderer.connect("edited", self.on_cell_edited, None)
        column = gtk.TreeViewColumn("歌曲", renderer, text=COL_TITLE)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data("column", COL_ARTIST)
        renderer.set_property('editable', True)
        renderer.connect("edited", self.on_cell_edited, None)
        column = gtk.TreeViewColumn("歌手", renderer, text=COL_ARTIST)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data("column", COL_ALBUM)
        renderer.set_property('editable', True)
        renderer.connect("edited", self.on_cell_edited, None)
        column = gtk.TreeViewColumn("专辑", renderer, text=COL_ALBUM)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data("column", COL_SIZE)
        column = gtk.TreeViewColumn("长度", renderer, text=COL_SIZE)
        column.set_resizable(True)
        treeview.append_column(column)
        return treeview

    def setDirView(self):
        #编号，文件名，标题，歌手，专辑，大小，绝对路径
        self.dirmodel = gtk.ListStore(str, str, str, str, str, str, str)
        treeview = gtk.TreeView(self.dirmodel)
        treeview.connect('button-press-event', self.onFileListRightClicked, None)
        treeview.get_selection().set_mode(gtk.SELECTION_SINGLE)
        
        renderer = gtk.CellRendererText()
        renderer.set_data('column', COL_FILE_NUM)
        column = gtk.TreeViewColumn('编号', renderer, text=COL_FILE_NUM)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data('column', COL_FILE_NAME)
        column = gtk.TreeViewColumn('文件名', renderer, text=COL_FILE_NAME)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data('column', COL_FILE_TITLE)
        renderer.set_property('editable', True)
        renderer.connect('edited', self.onFileCellEdit, None)
        column = gtk.TreeViewColumn('歌曲', renderer, text=COL_FILE_TITLE)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data('column', COL_FILE_ARTIST)
        renderer.set_property('editable', True)
        renderer.connect('edited', self.onFileCellEdit, None)
        column = gtk.TreeViewColumn('歌手', renderer, text=COL_FILE_ARTIST)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data('column', COL_FILE_ALBUM)
        renderer.set_property('editable', True)
        renderer.connect('edited', self.onFileCellEdit, None)
        column = gtk.TreeViewColumn('专辑', renderer, text=COL_FILE_ALBUM)
        column.set_resizable(True)
        treeview.append_column(column)

        renderer = gtk.CellRendererText()
        renderer.set_data('column', COL_FILE_SIZE)
        column = gtk.TreeViewColumn('大小', renderer, text=COL_FILE_SIZE)
        column.set_resizable(True)
        treeview.append_column(column)        
        
        #self.setDirModel(self.downdir)#速度太慢
        self.fileNum = 0
        return treeview

    def setDirModel(self, tdir):
        self.dirmodel.clear()
        if not os.path.exists(tdir):
            msg = gtk.MessageDialog(self, 0, gtk.MESSSAGE_ERROR, gtk.BUTTONS_OK,
                                    '路径有误！')
            msg.run()
            msg.destroy()
            return
        num = 0
        for files in os.listdir(tdir):
            path = os.path.join(tdir, files)            
            if not os.path.isdir(path):
                if files.endswith('.mp3'):
                    size = '%.3fM'%(os.stat(path)[6]/1024/1024.)
                    album = ''
                    artist = ''
                    title = ''
                    #"""
                    tagcmd = 'mid3v2 -l "'+path+'"'
                    out = os.popen(tagcmd)                    
                    for line in out.readlines():
                        if line.startswith('TALB='):
                            album = line.split('=')[1]
                            album = album[0: len(album)-1]
                        elif line.startswith('TPE1'):
                            artist = line.split('=')[1]
                            artist = artist[0: len(artist)-1]
                        elif line.startswith('TIT2'):
                            title = line.split('=')[1]
                            title = title[0: len(title)-1]
                    out.close()
                    #"""
                    num = num+1
                    self.dirmodel.append([num, files, title, artist, album, size, path])
        self.fileNum = num
                    

    def onFileListRightClicked(self, view, event, data):
        if event.type == gtk.gdk.BUTTON_PRESS and event.button == 3:
            selected = view.get_selection().get_selected()
            popupmenu = gtk.Menu()
            menuitem = gtk.MenuItem('播\t放')
            menuitem.connect('activate', self.play, selected)
            popupmenu.append(menuitem)
            menuitem = gtk.SeparatorMenuItem()
            popupmenu.append(menuitem)
            menuitem = gtk.MenuItem('从列表中清除')
            menuitem.connect('activate', self.remove, selected)
            popupmenu.append(menuitem)
            menuitem = gtk.MenuItem('删除文件')
            menuitem.connect('activate', self.delete2, selected)
            popupmenu.append(menuitem)
            popupmenu.show_all()
            popupmenu.popup(None, None, None, event.button,
                            event.get_time(), None)
        

    def search(self, pagenum=0):
        keyword = self.entry.get_text()
        if keyword == '':
            return
        self.url = newparser.getUrl(keyword)
        url = self.url+'&pn='+str(pagenum*30)
        (infos, urls) = newparser.listInfo(url)
        length = len(urls)
        self.model.clear()
        i = 0
        for ii in infos[:length]:
            i = i+1
            self.model.append([i, ii[0], ii[1], ii[2], ii[-2], urls[i-1]])

    def prepage(self, widget, data):
        if self.pageNum<=0:
            return
        self.pageNum = self.pageNum-1
        self.search(self.pageNum)
        self.page.set_text(str(self.pageNum+1))
        self.notebookup.set_current_page(1)

    def nextpage(self, widget, data):
        if self.pageNum<0:
            return
        self.pageNum = self.pageNum+1
        self.search(self.pageNum)
        self.page.set_text(str(self.pageNum+1))
        self.notebookup.set_current_page(1)

    def thispage(self, widget, data):
        num = int(self.page.get_text())
        if num == self.pageNum:
            return
        self.search(num-1)
        self.pageNum = num-1
        self.notebookup.set_current_page(1)
        
    def doSearch(self, widget, data):
        self.pageNum = 0
        self.page.set_text('1')
        self.search()
        self.notebookup.set_current_page(1)

    def refresh(self, button, data):
        listdir = self.entryFileDir.get_text()
        if not os.path.exists(listdir):
            msg = gtk.MessageDialog(self, 0, gtk.MESSAGE_ERROR,
                                    '路径设置有误！')
            msg.run()
            msg.destroy()
            return
        self.setDirModel(listdir)

    def on_cell_edited(self, cell, path_string, new_text, data):
        iter = self.model.get_iter_from_string(path_string)
        #path = model.get_path(iter)[0]
        column = cell.get_data("column")
        self.model.set(iter, column, new_text)

    def onFileCellEdit(self, cell, path_string, new_text, data):
        iter = self.dirmodel.get_iter_from_string(path_string)
        column = cell.get_data('column')
        oldtext = self.dirmodel.get_value(iter, column)
        if oldtext == new_text:
            return
        self.dirmodel.set(iter, column, new_text)
        tfile = self.dirmodel.get_value(iter, COL_FILE_PATH)
        #save to file
        tid = ''
        if column == COL_FILE_TITLE:
            tid = ' -t '
        elif column == COL_FILE_ARTIST:
            tid = ' -a '
        elif column == COL_FILE_ALBUM:
            tid = ' -A '
        else:
            return
        cmd = 'mid3v2'+tid+'"'+new_text+'" "'+tfile+'"'
        os.system(cmd)
        
    def on_vte_exit(self, vte, data):
        gtk.main_quit()
    def onSearchListRightClicked(self, view, event, data):
        if event.type == gtk.gdk.BUTTON_PRESS and event.button == 3:
            selected = view.get_selection().get_selected()
            popupmenu = gtk.Menu()
            menuitem = gtk.MenuItem('下载')
            menuitem.connect('activate', self.download, selected)
            popupmenu.append(menuitem)
            menuitem = gtk.MenuItem('试听')
            menuitem.connect('activate', self.listen, selected)
            popupmenu.append(menuitem)
            menuitem = gtk.MenuItem('删除已有下载')
            menuitem.connect('activate', self.delete, selected)
            popupmenu.append(menuitem)
            popupmenu.show_all()
            popupmenu.popup(None, None, None, event.button, event.get_time(), None)

    def getFile(self, data):
        model,iter = data
        if not iter:
            return None
        artist = model.get_value(iter, COL_ARTIST)
        title = model.get_value(iter, COL_TITLE)
        directory = self.entry2.get_text()
        if not os.path.exists(directory):
            msg = gtk.MessageDialog(self, 0, gtk.MESSAGE_ERROR, gtk.BUTTONS_OK,
                                    '路径设置有误！')
            msg.run()
            msg.destroy()
            return None
        if not directory.endswith('/'):
            directory = directory+'/'
        currentFile = directory+artist+'-'+title+'.mp3'
        return currentFile

    def download(self, widget, data):
        tfile = self.getFile(data)
        if not tfile:
            return
        model,iter = data
        artist = model.get_value(iter, COL_ARTIST)
        title = model.get_value(iter, COL_TITLE)
        album = model.get_value(iter, COL_ALBUM)
        size = model.get_value(iter, COL_SIZE)
        url = model.get_value(iter, COL_URL)
        musicurl = newparser.parseUrl(url)
        if os.path.exists(tfile):
            msg = gtk.MessageDialog(self, 0, gtk.MESSAGE_QUESTION, gtk.BUTTONS_YES_NO,
                                    '是否覆盖？')
            response = msg.run()
            if response == gtk.RESPONSE_NO:
                msg.destroy()
                return
            msg.destroy()
        if os.system("which axel")==0:
            downCmd = 'axel "'+musicurl+'" -o "'+tfile+'"';
        else:    
            downCmd = 'wget "'+musicurl+'" -O "'+tfile+'"';	
        editTagsCmd = 'mid3v2 -D "'+tfile+'" && mid3v2 -a "'+artist+'" -t "'+title+'" -A "'+album+'" "'+tfile+'"'
        cmd = downCmd+' && '+editTagsCmd+'\n'
        self.vteDown.feed_child(cmd)
        filename = artist+'-'+title+'.mp3'
        self.fileNum = self.fileNum + 1
        self.dirmodel.append([self.fileNum, filename, title, artist, album, size, tfile])
        self.notebook.set_current_page(1)

    def playFile(self, tfile):
        if not os.path.exists(tfile):
            msg = gtk.MessageDialog(self, 0, gtk.MESSAGE_ERROR, gtk.BUTTONS_OK,
                                    '没找到文件:\n'+tfile+'\n\t请先下载！')
            msg.run()
            msg.destroy()
            return
        cmd = '\x03 mplayer -nogui -f "'+tfile+'"\n'#\x03 <=> Ctrl+C
        self.vteListen.feed_child(cmd)
        self.notebook.set_current_page(0)

    def listen(self, widget, data):
        tfile = self.getFile(data)
        if not tfile:
            return
        self.playFile(tfile)

    def play(self, widget, data):
        model, iter = data
        if not iter:
            return
        tfile = model.get_value(iter, COL_FILE_PATH)
        self.playFile(tfile)

    def deleteFile(self, tfile):
        cmd = 'rm -rf "'+tfile+'"'
        os.system(cmd)

    def delete(self, widget, data):
        tfile = self.getFile(data)
        if not tfile:
            return
        self.deleteFile(tfile)

    def delete2(self, widget, data):
        model, iter = data
        if not iter:
            return
        tfile = model.get_value(iter, COL_FILE_PATH)
        self.deleteFile(tfile)
        model.remove(iter)

    def remove(self, widget, data):
        model, iter = data
        if not iter:
            return
        model.remove(iter)
        
    def setdir(self, widget, entry):
        dialog = gtk.FileChooserDialog('打开……', self, gtk.FILE_CHOOSER_ACTION_SELECT_FOLDER,
                                       (gtk.STOCK_CANCEL, gtk.RESPONSE_CANCEL,
                                        gtk.STOCK_OPEN, gtk.RESPONSE_OK))
        dialog.set_default_response(gtk.RESPONSE_CANCEL)
        response = dialog.run()
        if response == gtk.RESPONSE_OK:
            entry.set_text(dialog.get_filename())
        dialog.destroy()
    
def main():
    win = MainWindow();
    win.show_all()
    gtk.main()

if __name__ == '__main__':
    main()
