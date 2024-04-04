#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

my $config_path = "../conf.ini";

sub _read_conf {

    unless (open IN, $config_path) {
        die "Can't open '$config_path': $!";
    }

    my @result_array = qw{ };
    foreach my $line (<IN>) {
        chomp ($line);
        push @result_array, $line;
    }
    close IN;

    return @result_array;
}


my @resul_array = _read_conf;

say "$_" for (@resul_array);

