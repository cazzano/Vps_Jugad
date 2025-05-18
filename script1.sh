#!/bin/bash

#sudo pacman -Syu --needed --noconfirm;
sudo pacman -S fakeroot debugedit binutils git fish sudo --noconfirm --needed;
sudo bash user.sh;
su - test;

