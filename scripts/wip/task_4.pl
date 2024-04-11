#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;

my %user_prms = (
    "Vadim"   => "1",
    "Nikita"  => "12345",
    "Valeriy" => "12345",
    "Alexey"  => "12345"
);

sub _login {
    my ( $user_name, $user_passwd ) = @_;
    my $find_user_flag = 0;
    if ( exists $user_prms{$user_name} ) {
        my $passwd = $user_prms{$user_name};
        if ( defined $passwd && $passwd eq $user_passwd ) {
            $find_user_flag = 1;
        }
    }
    return $find_user_flag;
}

my ( $user_name, $user_passwd ) = @ENV{ qw/ user_name user_passwd / };
unless ( defined $user_name && defined $user_passwd ) {
    die "Пожалуйста добавьте оба параметра user_name, user_passwd в ENV \n";
}

if ( _login( $user_name, $user_passwd ) ) {
    say "Добро пожаловать, $user_name!";
}
else {
    say "Неверный логин или пароль";
}


