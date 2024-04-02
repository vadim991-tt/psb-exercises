#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use feature qw( switch );
no warnings qw( experimental::smartmatch );
use v5.10;

sub _perform_operation {

    my $left_operand = shift;
    my $operator = shift;
    my $right_operand = shift;

    given ($operator) {

        when ($_ eq "+") {
            return $left_operand + $right_operand;
        }
        when ($_ eq "-") {
            return $left_operand - $right_operand;
        }
        when ($_ eq "*") {
            return $left_operand * $right_operand;
        }
        when ($_ eq "/") {
            if ($right_operand == 0) {
                die "Недопустимое действие: деление на 0\n";
            }
            return $left_operand / $right_operand;
        }
        default {
            die "Unknown operator: $operator\n";
        }
    }

}

sub _beatify_result {

    my @result = ();
    my $expression = shift;

    my $low_priority_operator_found = 0;
    foreach my $elem (@$expression) {

        if ($elem eq '+' || $elem eq '-') {
            $low_priority_operator_found = 1;
        }

        if (($elem eq '*' || $elem eq '/') && $low_priority_operator_found) {
            unshift @result, "(";
            push @result, ")";
            $low_priority_operator_found = 0;
        }

        push @result, $elem;

    }

    return @result


}

sub _calculate {

    # Лист для хранения всего выражения
    my @expression = ();

    say "ВВОД КАЖДОГО ОПЕРАТОРА/ОПЕРАНДА ПРОИЗВОДИТСЯ НА НОВОЙ СТРОЧКЕ";
    say "ВВЕДИТЕ ПЕРВОЕ ЧИСЛО, ОПЕРАТОР И ВТОРОЕ ЧИСЛО :";

    chomp (my $left_value = <STDIN>);
    my $result = $left_value;
    push (@expression, $result);

    while (1) {

        chomp(my $operand = <STDIN>);
        if ($operand eq "=") {
            last;
        }

        chomp(my $right_value = <STDIN>);
        my $eval_res = eval { _perform_operation($result, $operand, $right_value) };

        if ($@) {
            say "$@";
        } else {
            $result = $eval_res;
            push (@expression, $operand);
            push (@expression, $right_value);
        }


        say "result: ($result)";
        say "ВВЕДИТЕ ОПЕРАТОР И ВТОРОЕ ЧИСЛО:";
    }


    my @beautified_expression = _beatify_result(\@expression);
    say ((join " ", @beautified_expression) . " = $result");
}


_calculate;

