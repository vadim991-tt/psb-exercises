#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use v5.10;
use lib '../lib/';
use tools;

sub _perform_login {
    my ($user_name, $user_passwd) = @_;
    if (tools::login($user_name, $user_passwd)) {
        say "Добро пожаловать, $user_name!";
    } else {
        say "Неверный логин или пароль";
    }
}

sub _perform_reg {
    my ($user_name, $user_passwd) = @_;
    if (tools::reg_usr($user_name, $user_passwd)) {
        say "Пользователь, $user_name успешное зарегистрирован!";
    } else {
        say "Ошибка регистрации пользователя!";
    }
}

my ($user_name, $user_passwd, $action) = tools::get_params_from_env;
if ($action eq 'reg') {
    _perform_reg($user_name, $user_passwd);
} elsif ($action eq 'log') {
    _perform_login($user_name, $user_passwd);
} else {
    die "Неизвестная операция: $action!\n";
}


