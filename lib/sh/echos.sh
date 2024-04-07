#!/bin/bash

_escape_fgcolor_red="\e[31m"
_escape_fgcolor_yellow="\e[33m"
_escape_reset="\e[m"

function echo_err() {
    echo -en "$_escape_fgcolor_red"
    echo "$@"
    echo -en "$_escape_reset"
}

function echo_warn() {
    echo -en "$_escape_fgcolor_yellow"
    echo "$@"
    echo -en "$_escape_reset"
}
