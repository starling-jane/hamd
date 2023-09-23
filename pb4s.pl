#!/usr/bin/perl

require LWP::UserAgent;

my $uri = $ARGV[0];

my $token = $ARGV[1];

my $ua = LWP::UserAgent->new(timeout => 10);

my $response = $ua->get("$uri/api/v1/timelines/home", 'Authorization' => "Bearer $token");

print $response->decoded_content;
