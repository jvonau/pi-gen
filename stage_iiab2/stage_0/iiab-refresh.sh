#!/bin/bash
set -e
BASEDIR=/opt/iiab
CONFDIR=/etc/iiab
FLAGDIR=$CONFDIR/install-flags
UPDATE=0
INTERACTIVE=1

if [ "$1" = "--update" ]; then
    shift 1
    UPDATE=1
fi

if [ "$1" = "--non-interactive" ]; then
    shift 1
    INTERACTIVE=0
fi

if [ "$1" = "--reinstall" ]; then
    shift 1
    rm $FLAGS/iiab*complete || true
fi

check_branch(){
    cd $BASEDIR/iiab
    git branch | grep -q release-7.1
}

use_master(){
    cd $BASEDIR
    if [ -d iiab ]; then
        cd iiab
        git checkout -b master || true # covers older curls of release-7.1
        git config branch.master.remote origin # covers older curls of release-7.1
        git config branch.master.merge refs/heads/master # covers older curls of release-7.1
        git reset --hard 4ec760db08e2dd54d14a72fc388693d460b42710 # last common point
    fi
    cd $BASEDIR
    if [ -d iiab-admin-console ]; then
        cd iiab-admin-console
        git checkout -b master || true # covers older curls of 0.4.2
        git config branch.master.remote origin # covers older curls of 0.4.2
        git config branch.master.merge refs/heads/master # covers older curls of 0.4.2
    fi
}

update_master(){
    cd $BASEDIR
    if [ -d iiab ]; then
        cd iiab
        git checkout master
        git pull
    fi
    cd $BASEDIR
    if [ -d iiab-admin-console ]; then
        cd iiab-admin-console
        git checkout master
        git pull
    fi
}

if check_branch == 1; then
    echo -e "found release-7.1 branch would you like (re)install using the latest master?[Y/n]"
    ans=""
    if [ $INTERACTIVE == 1 ]; then
        read -t 5 ans < /dev/tty
    fi
    if [ "$ans" == "y" ] || [ "$ans" == "Y" ]; then
        UPDATE=1
    else
        echo "remaning on release-7.1 branch updating"
        cd $BASEDIR/iiab
        git checkout release-7.1
        git pull origin release-7.1
        cd $BASEDIR
        if [ -d iiab-admin-console ]; then
            cd iiab-admin-console
            git checkout 0.4.2
            git pull origin 0.4.2
        fi
    fi
fi

if [ $UPDATE == 1 ]; then
    use_master
    update_master
fi

if [ -f $FLAGDIR/iiab-complete ]; then
    if [ "$1" == "--upgrade" ]; then
        cd $BASEDIR/iiab
        git pull
        if [ -f $BASEDIR/iiab/upgrade_roles ]; then
            for force in $(cat $BASEDIR/iiab/upgrade_roles); do
                sed -i -e '/^$force/d' $CONFDIR/iiab_state.yml
            done
        fi
        ./iiab-configure
    else
        echo -e "\n\nIIAB INSTALLATION (/usr/sbin/iiab) IS ALREADY COMPLETE -- per existence of:"
        echo -e "$FLAGDIR/iiab-complete -- nothing to do.\n"
        exit 0
    fi
fi
