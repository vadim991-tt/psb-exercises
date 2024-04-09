#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use experimental 'smartmatch';
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

    _validate_input($user_name, $user_passwd);

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

sub _perform_passwd_change {
    my ($user_name, $new_user_passwd) = @_;

    _validate_input($user_name, $new_user_passwd);

    tools::change_passwd($user_name, $new_user_passwd);
}


if (tools::check_if_help_request) {
    tools::print_help_information;
    exit;
}


my ($user_name, $user_passwd, $action) = tools::get_params_from_env;


given($action) {
    when ('reg') {
        _perform_reg($user_name, $user_passwd);
    }
    when ('log') {
        _perform_login($user_name, $user_passwd);
    }
    when ('del') {
        _perform_deletion($user_name);
    }
    when ('change_passwd') {
        _perform_passwd_change($user_name, $user_passwd);
    }
    default {
        die "Неизвестная операция: $action!\n";
    }
}

