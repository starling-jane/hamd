#!/usr/bin/perl

my $is_link_regex = qr/\[[^\]]*\]\([^\)]*\)/;
my $parse_link_regex = qr/\[([^\]]*)\]\(([^\)]*)\)/;

my @in_line_re = [
    qr/\[[^\]]*\]\([^\)]*\)/,     #link
    qr/(?<!\\)\*\*.*?\*\*/,         #bold
    qr/(?<!\\)\*.*?\*/,             #emphasis
    ];

package Hamd::Section;
use strict;
use Curses;

sub new {
    my $class = shift;
    #print("@_");
    #my @running_array = @_;

    #split(/(@in_line_re[0])/, shift);

    # factor out to Hamd::Link?
    
    #while($running_array[-1] =~ /$is_link_regex/){
    #    my $to_parse = pop(@running_array);
    #    push(@running_array, split /($is_link_regex)/, $to_parse );
    #    }
    #for(@running_array){
    #    if($_ =~ /$is_link_regex/){
    #        $_ = Hamd::Link->new($_);
    #    }
    #}
    my @to_contents = split(/($is_link_regex)/, shift);
    for (@to_contents){
        if($_ =~ /($is_link_regex)/){
            $_ = Hamd::Link->new($_);
        }
    }

    my $self = {
        #_contents => [ @running_array ],
        _contents => [ @to_contents ],
        #_index => 0,
        #_contents => @{ @_ };
    };
    #my @t = @{ $self->{_contents}};
    #for(@t){
    #    print("$_");
    #}

    bless $self, $class;

    #for($self->contents){
    #    if($_ =~ /($is_link_regex)/){
    #        $_ = Hamd::Link->new($_);
    #    }
    #}
    return $self;
}
sub contents {
    my ($self) = @_;
    return $self->{_contents};
}
sub render {
    my ($self, $active, $active_x, $win, $y, $x, %colors) =  @_;
    
    # so that you can pass @_ to other stuff without attaching
    # the paragraph object
    shift(@_);
    my $i = -1;
    if($active){
        $i = 0;
    }
    my @running_array = @{$self->contents};
    my $r_x = $x;
    my $r_y = $y;
    for(@running_array){

        # everything should be a ref (maybe except plaintext..?)
        # then check $_->type and go from there
        if(ref($_)){
            $_->render($active && $i == $active_x, $win, $r_y, $r_x, %colors);
            if($_->type eq 'link' && $active){
                $i += 1;
            }
            $r_x += length($_->text);
        }

        # render plain text
        else{
            if($_ =~ /\n/){
                #if($_ eq "\n"){
                #    $r_y += 1;
                #    $r_x = 0;
                #}
                #else{
                #if($_ ne "\n"){
                    my @lines = split(/(\n)/, $_);
                    #shift(@lines);
                    my $first_line = shift(@lines);
                    #my $first_line = $lines[0];
                    $win->addstr($r_y, $r_x, $first_line);
                    #$win->addstr($r_y, $r_x, shift(@lines));
                    foreach my $l (@lines){
                        $r_y += 1;
                        $r_x = 0;
                        $win->addstr($r_y, $r_x, $l);
                        $r_x += length($l);
                    }
                    #$r_y += 1;
                    #$r_x = 0;
                #}
            }
            else{
                $win->addstr($r_y, $r_x, $_);
                $r_x += length($_);
            }
        }
    }
    return $r_y;
}
1;
