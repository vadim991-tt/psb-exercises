#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

my $config_path = "../conf.ini";

sub _read_conf {

    unless (open IN, $config_path) {
        die "Can't open '$config_path': $!";
    }

    my %config = qw{ };
    foreach my $line (<IN>) {
        chomp ($line);

        # Удаление всех пробелов и табуляций
        $line =~ s/\s+//g;

        # Пропуск комментариев и пустых строк
        if ($line =~ /^#/ || $line eq '') {
            next;
        }

        # Использование регулярных выражений для извлечения ключа и значения
        if ($line =~ m/^([^=]+)=(.+)$/) {
            my $key = $1;
            my $value = $2;
            # Проверка на непустые ключ и значение
            if ($key ne '' && $value ne '') {
                $config{$key} = $value;
            }
        }
    }
    close IN;

    return %config;
}


my %config = _read_conf;

say "$_ => $config{$_}" for (keys %config);

