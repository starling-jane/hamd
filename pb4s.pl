#!/usr/bin/perl

require JSON::Parse;
require LWP::UserAgent;
require HTML::Entities;

my $uri = $ARGV[0];

my $token = $ARGV[1];
my $limit = 5;
my $api_request = "/api/v1/timelines/home?limit=$limit";

my $ua = LWP::UserAgent->new(timeout => 10);

my $response = $ua->get("$uri$api_request", 'Authorization' => "Bearer $token")->decoded_content;
my @timeline = JSON::Parse::parse_json($response);
print $timeline[0][1]->{account}->{acct};
print $timeline[0][1]->{content};
#print $timeline[0];
for (my $i = 0; $i < $limit; $i++){
    print "$timeline[0][$i]->{account}->{username} [($timeline[0][$i]->{account}->{acct})]($timeline[0][$i]->{account}->{url})\n";
    print HTML::Entities::decode_entities("$timeline[0][$i]->{content}\n\n");
}
#print $response;
