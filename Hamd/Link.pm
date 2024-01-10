#!/usr/bin/perl

#HAMD = Hooray! All MarkDown

package Hamd::Link;
use strict;
use Curses;

sub new {
    my $class = shift;
    my $raw = shift;
    $raw =~ /\[([^\]]*)\]\(([^\)]*)\)/;
    my $self = {
        _text => $1,
        _href => $2,
    };
    bless $self, $class;
    return $self;
}
sub render {
    my ($self, $active, $win, $y, $x, %colors) = @_;
    if($active){
        $win->attron(Curses::COLOR_PAIR($colors{'hover'}));
        $win->addstr($y, $x, $self->text);
        $win->attroff(Curses::COLOR_PAIR($colors{'hover'}));
    }
    else{
        $win->attron(Curses::COLOR_PAIR($colors{'link'}));
        $win->addstr($y, $x, $self->text);
        $win->attroff(Curses::COLOR_PAIR($colors{'link'}));
    }
}
sub type {
    return('link');
}

sub text {
    my ($self) = @_;
    return $self->{_text};
}
sub href {
    my ($self) = @_;
    return $self->{_href};
}
1;
