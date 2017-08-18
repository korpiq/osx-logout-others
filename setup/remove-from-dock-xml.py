#!/usr/bin/env python

import sys
import xml.etree.ElementTree as elemTree


def get_by_key(key_name, apple_dict, strict=True):
    for i in range(0,len(apple_dict)):
        child = apple_dict[i]
        if child.tag == 'key' and child.text == key_name:
            return apple_dict[i+1]

    if strict:
        raise ValueError("Missing %s in %s" % (key_name, str(apple_dict)))


def find_persistent_app(name, value, persistent_apps):
    for app_dict in persistent_apps:
        tile_data = get_by_key('tile-data', app_dict)
        field = get_by_key(name, tile_data, False)
        if field is not None and field.text == value:
            return app_dict


def remove_app(label, plist):
    main_dict = plist[0]
    
    persistent_apps = get_by_key('persistent-apps', main_dict)
    
    target = find_persistent_app(
        'bundle-identifier', 'fi.iki.korpiq.Logout_Others', persistent_apps
    )
    if target is not None:
        persistent_apps.remove(target)


tree = elemTree.parse(sys.stdin)
plist = tree.getroot()
remove_app('Logout_Others', plist)
tree.write(sys.stdout, encoding='UTF-8')
