#!/usr/bin/perl -w

use strict;
use Curses;

my $win = new Curses;
$win->addstr(10, 10, 'foo');
$win->refresh;
