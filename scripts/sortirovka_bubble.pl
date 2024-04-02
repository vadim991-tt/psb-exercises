#!/usr/bin/perl
use warnings FATAL => 'all';
use v5.10;
use strict;


### BUBBLE SORT
sub bubble_sort {

    my $array = shift;
    my $last_inx = @{$array} - 1;
    my $swapped_flag;
    my $i = 0;

    while ($i != $last_inx) {

        # Сравниваем элементы по-парно
        # Каждый раз уменьшая правый интервал (там уже все отсортировано)
        for (my $j = 0; $j < $last_inx - $i; $j++) {

            $swapped_flag = 0;

            if ($array->[$j] > $array->[$j + 1]) {
                ($array->[$j], $array->[$j + 1]) = ($array->[$j + 1], $array->[$j]);
                $swapped_flag = 1;
            }
        }

        # Досрочный выход из цикла если не было
        # никаких перемещений
        unless ($swapped_flag) {
            last;
        }

        $i++;
    }
}
###


### TESTS
sub _test_bubble_sort {
    my @array = (5, 6, 3, 1, 7, 3, 2, 9, 10, 4, 1);
    say "ARRAY BEFORE: ";
    say join " ", @array;
    bubble_sort(\@array);
    say "ARRAY AFTER: ";
    say join " ", @array;
}

_test_bubble_sort;
###

