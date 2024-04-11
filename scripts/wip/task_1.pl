#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

my @user_list = qw/ Vadim Nikita Valeriy Alexey /;
chomp( my $user_name = <STDIN> );

my $find_user_flag = 0;
foreach my $user ( @user_list ) {
    if ( $user_name eq $user ) {
        $find_user_flag = 1;
    }
}

if ( $find_user_flag ) {
    say "Добро пожаловать, $user_name !";
}
else {
    say "Ты кто такой, $user_name?!";
}
