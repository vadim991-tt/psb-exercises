#!/usr/bin/perl
use strict;
use v5.10;
use warnings FATAL => 'all';
use lib '../lib/tools.pm';
require "tools.pm";

my ( $user_name, $user_passwd ) = tools::get_params_from_env;
if ( tools::login( $user_name, $user_passwd ) ) {
    say "Добро пожаловать, $user_name!";
}
else {
    say "Неверный логин или пароль";
}