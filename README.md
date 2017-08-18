Logout Others on OSX
====================

Tiny hack to allow a Mac user force other users' session to end.

My kids share a Macbook but they always forget to log out,
preventing each other from using e.g. Steam.
This is a faster and less forceful way for them to take control of the machine
than forcing a reboot.

Requirements
------------

 - OS X Yosemite 10.10.5 (tested; does not work on Sierra 10.12.6)
 - Installation and uninstallation require superuser (sudo) privileges

Contents
--------

 - Application: `Logout_Others.app`
 - sudo configuration file to allow users to logout others with superuser privileges
 - scripts to install and uninstall the app and show it in users' Docks.

Install
-------

Run the `install` script in Terminal. Superuser privileges will be requested.

It puts application in Applications folder, sudo configuration in place,
and adds the app to every user's Dock.

Installation script is idempotent, ie. it can be run repeatedly for updates.

Uninstall
---------

Run the `uninstall` script in terminal. Superuser privileges will be requested.

It moves to trash the application and sudo configuration,
and removes the application from every user's Dock.

