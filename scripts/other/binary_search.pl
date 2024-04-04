#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

### BINARY SEARCH
sub binary_search {

    if (@_ != 4) {
        die "Пожалуйста, предоставьте правильные параметры: array_link, left_inx, right_inx, value";
    }

    my ($array, $left, $right, $elem_to_find) = @_;

    if ($right < $left) {
        return -1;
    }

    my $middle =  int ($left + (($right - $left) / 2));
    if ($array->[$middle] == $elem_to_find) {
        return $middle;
    } elsif ($array->[$middle] > $elem_to_find) {
        return binary_search($array, $left, $middle - 1, $elem_to_find);
    } else {
        return binary_search($array, $middle + 1, $right, $elem_to_find);
    }

}
###


### TESTS
sub _test_binary_search {

    say "ВВЕДИТЕ ЧИСЛО: ";
    chomp(my $elem = <STDIN>);
    if ($elem =~ /\D/) {
        die "'$elem' не является числом! Передайте пожалуйста число!\n";
    }

    my @array = (1, 2, 3, 4, 5);
    say "МАССИВ: " . join " ", @array;
    say "ЭЛЕМЕНТ КОТОРЫЙ ИЩЕМ: $elem";

    my $inx = binary_search(\@array, 0, $#array, $elem);
    say "ЭЛЕМЕНТ $elem МОЖЕТ БЫТЬ НАЙДЕН ПО ИНДЕКУ: $inx";

}


_test_binary_search;
###