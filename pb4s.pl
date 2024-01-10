#!/usr/bin/perl

require JSON::Parse;
require LWP::UserAgent;
require HTML::Entities;

my $uri = $ARGV[0];
my $token = $ARGV[1];
my $limit = 5;
my $api_request = "/api/v1/timelines/home?limit=$limit";

my $ua = LWP::UserAgent->new(timeout => 10);

my $a_regex = /<a href="([^"]*)">([^<]*)<\/a>/;
my $a_regex_alt = /<a href='([^']*)'>([^<]*)<\/a>/;
my $b_regex = /<b>([^<]*)<\/b>/;
my $i_regex = /<i>([^<]*)<\/i>/;
my $strong_regex = /<strong>([^<]*)<\/strong>/;
my $em_regex = /<em>([^<]*)<\/em>/;
my $p_regex = /<p>([^<]*)<\/p>/;

my $response = $ua->get("$uri$api_request", 'Authorization' => "Bearer $token")->decoded_content;
my @timeline = JSON::Parse::parse_json($response);

for (my $i = 0; $i < $limit; $i++){
    print "$timeline[0][$i]->{account}->{username} [($timeline[0][$i]->{account}->{acct})]($timeline[0][$i]->{account}->{url})";
    $content = "$timeline[0][$i]->{content}\n";
    # change HTML of posts to markdown
    
    # links
    $content =~ s/<a href='([^']*)'[^>]*>[ \n]*(.*?)[ \n]*(?=<\/a>)/\[$2\]\($1\)/g;
    $content =~ s/<a href="([^"]*)"[^>]*>[ \n]*(.*?)[ \n]*(?=<\/a>)/\[$2\]\($1\)/g;
    $content =~ s/<\/a>//g;
    # paragraph handling a little weird because <p> isn't always closed
    $content =~ s/<p>([^<]*)(?=<)/$1\n/g;
    $content =~ s/<\/p>//g;
    # line breaks
    $content =~ s/[^\$]<br( \/)?>/\n/g;
    # formatting
    $content =~ s/<b>/**/g;
    $content =~ s/<strong>/**/g;
    $content =~ s/<\/b>/**/g;
    $content =~ s/<\/strong>/**/g;
    $content =~ s/<i>/*/g;
    $content =~ s/<em>/*/g;
    $content =~ s/<\/i>/*/g;
    $content =~ s/<\/em>/*/g;
    # unrecognized html will just get stripped for readability
    $content =~ s/<[^<>]*?>//g;
    $reblog = $timeline[0][$i]->{reblog};
    if($reblog == null){
        print "\n";
    }
    else{
        print " >> $reblog->{account}->{username} [($reblog->{account}->{acct})]($reblog->{account}->{url})\n";
    }
    print HTML::Entities::decode_entities("$content");
}
#print $response;
