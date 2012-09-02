-*- mode: outline; coding: utf-8 -*-

* Source code bazaar revision: 106722

* Source code checked out from Emacs Bazaar repository on 2011-12-23:
bzr branch --stacked http://bzr.savannah.gnu.org/r/emacs/trunk

* Compiled on Windows 7 Ultimate with  MinGW:
configure.bat --with-gcc --no-cygwin --no-debug
make bootstrap

* Edit Windows Registry as needed:

[HKEY_LOCAL_MACHINE\SOFTWARE\GNU\Emacs]
"Emacs.Background"="Black"
"Emacs.Foreground"="Wheat"
"Emacs.ScrollBars"="OFF"
"Emacs.MenuBar"="OFF"
"Emacs.ToolBar"="OFF"
"Emacs.Geometry"="125x43+0+0"

* To add an "Open With Emacs" pop-up menu in your system: 
** in your .emacs, add:
(server-start)

** double click the "popup-menu.reg" file or edit your Windows Registry:
[HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\Open With Emacs\command]
@="C:\\emacs\\bin\\emacsclientw.exe -n -a \"C:\\emacs\\bin\\runemacs.exe\" \"%1\""
