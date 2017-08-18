
# settings -- you can override ROOT_DIR

ROOT_DIR="$ROOT_DIR/"
NAME=Logout_Others
APP="Applications/$NAME.app"
CONF_DIR="private/etc/sudoers.d"

usage () {
    [ -n "$*" ] && echo "$*"$'\n' >&2
    cat >&2 <<-END
	Usage: [ROOT_DIR=some_dir] $0
	$USAGE
	END
    exit 1
}

run_as_root () {
    if [ "$UID" != "0" ]
    then
        echo "=== Requesting to run with superuser privileges: $0 $*" >&2
        exec sudo "$0" "$@"
    fi
}

[ -d "$ROOT_DIR" ] || usage "Missing root directory '$ROOT_DIR'"
[ -n "$*" ] && usage "This command takes no parameters."

run_as_root

user_has_dock_running () {
    ps ax -o user,comm | grep -q "^$1.*Dock$"
}

remember_user_with_changed_dock () {
    USERS_WITH_CHANGED_DOCK="$USERS_WITH_CHANGED_DOCK $1"
}

reload_changed_docks () {
    for TARGET_USER in $USERS_WITH_CHANGED_DOCK
    do
        reload_dock_for_user "$TARGET_USER"
    done
}

reload_dock_for_user () {
    sudo -u "$1" killall Dock
}

user_has_app_in_dock () {
    sudo -u "$1" \
        defaults read com.apple.dock persistent-apps |
        grep -q "$2"
}

each_user_with_app_in_dock () {
    APP="$1"
    HAS_APP="$2"
    WITHOUT_APP="$3"
    USERS_WITH_CHANGED_DOCK=""
    for TARGET in /Users/*/Library/Preferences/com.apple.dock.plist
    do
        TARGET_USER=$(echo "$TARGET" | sed -e 's:^/Users/::; s:/.*::')
        echo "==  User $TARGET_USER"
        DOCK_CHANGED=""
        if user_has_app_in_dock "$TARGET_USER" "$APP"
        then
            "$HAS_APP" "$TARGET_USER" "$TARGET"
        else
            "$WITHOUT_APP" "$TARGET_USER" "$TARGET"
        fi
        [ -n "$DOCK_CHANGED" ] &&
            user_has_dock_running "$TARGET_USER" &&
            remember_user_with_changed_dock "$TARGET_USER"
    done

    if [ -n "$USERS_WITH_CHANGED_DOCK" ]
    then
        echo "=== Reloading changed docks: $USERS_WITH_CHANGED_DOCK"
        sleep 1
        reload_changed_docks
    fi
}

remove_app_from_dock () {
    echo "=   removing $NAME from Dock"
    "$THIS_DIR/setup/remove-from-dock.sh" "$1" "$2"
    DOCK_CHANGED=1
}

