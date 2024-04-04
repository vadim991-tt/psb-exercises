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

sub _validate_input {
    my ($user_name, $user_passwd) = @_;
    tools::check_user_name($user_name) &&
        tools::check_user_passwd($user_passwd)
        || die "Ошибка валидации!\n";
}

sub _perform_deletion {
    my $user_name = shift;
    tools::delete_user($user_name) || die "Невозможно удалить пользователя!";
}


my ($user_name, $user_passwd, $action) = tools::get_params_from_env;

if ($action eq 'reg') {
    _validate_input($user_name, $user_passwd);
    _perform_reg($user_name, $user_passwd);
} elsif ($action eq 'log') {
    _perform_login($user_name, $user_passwd);
} elsif ($action eq 'del') {
    _perform_deletion($user_name);
} else {
    die "Неизвестная операция: $action!\n";
}


