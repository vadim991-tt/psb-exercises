#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;


my @user_list = qw{ Vadim Nikita Valeriy Alexey };

my ($user_name, $user_passwd) = @ENV{ qw /user_name user_passwd/ };
unless (defined $user_name && defined $user_passwd) {
    die "Пожалуйста добавьте оба параметра user_name, user_passwd в ENV \n";
}

my $find_user_flag = 0;
foreach my $user (@user_list) {
    if ($user_name eq $user) {
        $find_user_flag = 1;
    }
}

if ($find_user_flag) {
    say "Добро пожаловать, $user_name! Твой пароль: $user_passwd";
} else {
    say "Ты кто такой, $user_name?!";
}
