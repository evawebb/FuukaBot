#!/bin/bash

export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 

echo ">>>> $USER"
echo ">>>> $(which ruby)"
echo ">>>> $PATH"

ruby main.rb
