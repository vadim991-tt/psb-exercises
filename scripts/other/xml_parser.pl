#!/usr/bin/perl
use strict;
use warnings;
use XML::Simple;
use Data::Dumper;
use v5.10;

my $filename = $ARGV[0];
unless (defined $filename && $filename ne '') {
    die "Введите имя файла!\n";
}

my $xml = XML::Simple->new;
my $data = eval {
   return $xml->XMLin($filename, ForceArray => 0, KeyAttr => []);
};

if ($@) {
    die "Ошибка при чтении XML файла: $@\n";
}

foreach my $key (keys %{$data}) {
    say "$key => $data->{$key}";
}