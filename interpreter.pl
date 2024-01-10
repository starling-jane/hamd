#!/usr/bin/perl -w

use strict;
use Curses;
use Term::ReadKey;


use lib '/home/starling/pb4s';
use Hamd::Link;
use Hamd::Section;

#my $test = Hamd::Line->new("this is my [uwu](<.<) thhiiiningin [link](bo) hhff");
#my $test = new Hamd::Link;
#print($test->render);

my $hyperlink_re = qr/\[([^\]]*)\]\(([^\)]*)\)/;

#slurp
open my $fh, '<', 'example.md' or die$!;
read $fh, my $file_content, -s $fh;

my $test = Hamd::Section->new($file_content);

initscr;
my $win = new Curses;
Curses::start_color;

my $DEFAULT_COLOR = 1;
my $LINK_COLOR = 2;
my $LINK_HOVER_COLOR = 3;

my $active_y = 0;
my $active_x = 0;

Curses::init_pair(1, Curses::COLOR_WHITE, Curses::COLOR_BLACK);
Curses::init_pair(2, Curses::COLOR_BLUE, Curses::COLOR_WHITE);
Curses::init_pair(3, Curses::COLOR_WHITE, Curses::COLOR_BLUE);

my %colors =    (   default => 1,
                    link    => 2,
                    hover   => 3
                );
#my $pair = $win->init_pair(0, 0);
#my ($ch, $key) = getchar;

#ReadMode 'raw';
#my $key = ReadKey(0);
#ReadMode 'restore';
#print("$ch\n");
#($ch, $key) = getchar;
#print("$ch\n");



# main loop
my $break_condition = 1;
while ($break_condition){

    # key input
    ReadMode('raw');
    my $char = ReadKey(0);
    if($char eq chr(0x1b)){
        my $char_1 = ReadKey(0);
        my $char_2 = ReadKey(0);
        $char = "^[$char_1$char_2";
        #print("ESC SEQ: $char_1 $char_2\n");
    }
    ReadMode('normal');
    if($char eq "^[[D"){ #left
        $active_x -= 1;
    }
    if($char eq "^[[C"){ #right
        $active_x += 1;
    }
    if($char eq "^[[A"){ #up
        $active_y -= 1;
    }
    if($char eq "^[[B"){ #down
        $active_y += 1;
    }
    if($char eq "\r"){   #enter
        print("ENTER");
    }
    if($char eq "q"){
        $break_condition = 0;
    }

    #rendering
    $test->render(1, $active_x, $win, 1, 1, %colors);
    $win->refresh;
}

#$win->addstr(1, 1, 'foo');
#$test->render(1, $active_x, $win, 1, 1, %colors);
#$win->addstr(2, 2, $key eq "f");
#$win->refresh;
#sleep(3);
endwin;
