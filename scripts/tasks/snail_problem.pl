#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

sub _calculate_sprints {

    my ( $total_tasks, $task_solved_per_day, $task_created_per_day ) = @_;

    my $daily_diff = $task_solved_per_day - $task_created_per_day;

    my $result = int( $total_tasks / ( $daily_diff * 10 ));

    my $success_string = "Улиточка справится за $result спринтов" x ( $result > 0 );

    my $fail_string = "Улиточка не справится :(" x ( $result <= 0 );

    say $success_string . $fail_string;

}

_calculate_sprints( 100, 12, 15 );