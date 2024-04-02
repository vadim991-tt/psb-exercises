#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

my $config_path = "/home/vadim/IdeaProjects/psb-exercises/conf.ini";

sub _read_conf {

    unless (open IN, $config_path) {
        die "Can't open '$config_path': $!";
    }

    my %result_hash = qw{ };
    foreach my $line (<IN>) {
        chomp ($line);
        my ($user_name, $pass) = split(/=/, $line);
        $result_hash{$user_name} = $pass;
    }

    close IN;

    return %result_hash;
}


my %config = _read_conf;

say "$_ => $config{$_}" for (keys %config);

