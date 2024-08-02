#!/usr/bin/env python3

import argparse
import os
import pathlib
import shutil
import subprocess
import sys


def run(cmd):
    print(f'+ {cmd}')
    subprocess.run(cmd, shell=True)


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--rebuild', action='store_true', help='Rebuild the nix config.')
    parser.add_argument('--tz', help='Set the timezone.')
    parser.add_argument('--hostname', help='Set the hostname.')
    return parser.parse_args()

def main():
    args = parse_args()
    tz = 'Europe/Athens'
    tzfile = pathlib.Path('/home/dylan/.tz')
    if tzfile.is_file():
        with tzfile.open() as f:
            tz = f.read()
    if args.tz:
        tz = args.tz
    hostnamefile = pathlib.Path('/home/dylan/.hostname')
    hostname = None
    if hostnamefile.is_file():
        with hostnamefile.open() as f:
            hostname = f.read()
    if args.hostname:
        hostname = args.hostname
    if hostname is None:
        sys.stderr.write('Please provide hostname.\n')
        sys.stderr.flush()
        sys.exit(1)
    with open('base.nix', 'r') as f:
        conf = f.read()
    conf = conf.replace('{{ timezone }}', tz)
    with open('/etc/nixos/base.nix', 'w') as f:
        f.write(conf)
    shutil.copy(f'{hostname}.nix', '/etc/nixos/configuration.nix')
    if args.rebuild:
        run('nixos-rebuild switch')
    run(f'curl -fLo home/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
    home = pathlib.Path('home')
    for user in ('dylan', 'c'):
        userhome = pathlib.Path('/home') / user
        # Change to Path.walk with python 3.12
        for dirpath, dirnames, filenames in os.walk(home):
            for filename in filenames:
                if filename.endswith(".swp"):
                    continue
                filepath = pathlib.Path(dirpath) / filename
                relpath = filepath.relative_to(home)
                dest  = userhome / relpath
                dest.parent.mkdir(parents=True, exist_ok=True)
                shutil.chown(dest.parent, user=user, group='users')
                shutil.copy(filepath, dest)
                shutil.chown(dest, user=user, group='users')
    run('kill -USR2 $(pgrep waybar)')


if __name__ == '__main__':
    main()
