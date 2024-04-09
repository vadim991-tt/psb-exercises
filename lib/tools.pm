package tools;
use strict;
use warnings FATAL => 'all';
use v5.10;

our $config_path = "../conf.ini";

sub read_conf {

    unless (open IN, $config_path) {
        die "Can't open '$config_path': $!";
    }

    my %config = qw{ };
    foreach my $line (<IN>) {
        chomp ($line);

        # Удаление всех пробелов и табуляций
        $line =~ s/\s+//g;

        # Пропуск комментариев и пустых строк
        if ($line =~ /^#/ || $line eq '') {
            next;
        }

        # Использование регулярных выражений для извлечения ключа и значения
        if ($line =~ m/^([^=]+)=(.+)$/) {
            my $key = $1;
            my $value = $2;
            # Проверка на непустые ключ и значение
            if ($key ne '' && $value ne '') {
                $config{$key} = $value;
            }
        }
    }
    close IN;

    return %config;
}

sub login {
    my %user_prms = read_conf;
    my ($user_name, $user_passwd) = @_;
    my $find_user_flag = 0;
    if (defined $user_name &&
        defined $user_passwd &&
        exists $user_prms{$user_name}) {
        my $passwd = $user_prms{$user_name};
        if (defined $passwd && $passwd eq $user_passwd) {
            $find_user_flag = 1;
        }
    }
    return $find_user_flag;
}

sub reg_usr {
    my %user_prms = read_conf;
    my ($user_name, $user_passwd) = @_;

    unless (defined $user_name && defined $user_passwd) {
        say "Не инициализрованный логин или пароль";
        return 0;
    }

    if (exists $user_prms{$user_name}) {
        say "Пользователь с таким никнеймом уже зарегистрирован";
        return 0;
    }

    $user_prms{$user_name} = $user_passwd;
    rewrite_config (\%user_prms);

}

sub get_params_from_env {

    my ($user_name, $user_passwd, $action) = @ENV{ qw /user_name user_passwd action/ };
    unless (defined $user_name && defined $action) {
        die "Пожалуйста добавьте параметры user_name, user_passwd (optional), action в ENV \n";
    }
    return ($user_name, $user_passwd, $action);
}

sub rewrite_config {

    my $config = shift;
    open my $fh, ">", $config_path or die "Can't open '$config_path': $!";

    foreach my $key (keys %$config) {
        my $value = $config->{$key};
        say $fh "$key=$value";
    }


    close $fh;
}

sub check_user_name {
    my ($user_name) = @_;

    # Проверка логина
    if ($user_name =~ m/^[a-zA-Z][a-zA-Z0-9_-]*[a-zA-Z0-9]$/) {
        return 1;
    } else {
        say
        "Логин невалиден: должен начинаться с буквы, может содержать цифры, тире, нижнее
        подчеркивание, заканчиваться на цифру или букву,
        не содержать кириллицу.";
        return 0;
    }
}


sub check_user_passwd {
    my ($password) = @_;

    unless (length($password) >= 8) {
        say 'Пароль должен быть не менее 8 символов';
        return 0;
    }
    unless ($password =~ m/^[a-zA-Z]/) {
        say 'Пароль должен начинаться с латинской буквы';
        return 0;
    }
    unless ($password =~ m/[!@#\$^%&*()]/) {
        say 'Пароль должен содержать минимум один спецсимвол из списка !@#$\%^&*()';
        return 0;
    }
    unless ($password =~ m/[A-Z]/) {
        say 'Пароль должен содержать минимум один символ в верхнем регистре';
        return 0;
    }
    unless ($password =~ m/\d/) {
        say 'Пароль должен содержать минимум одну цифру';
        return 0;
    }

    return 1;
}

sub delete_user {
    my $user_name = shift;
    my %config = read_conf;
    if (exists $config{$user_name}) {
        delete $config{$user_name};
        rewrite_config \%config;
        say "Пользователь [$user_name] был успешно удален!";
        return 1;
    }

    say "Пользователь [$user_name] не был удален т.к. он не существовал в базе!";
    return 0;
}


sub change_passwd {

    my ($user_name, $new_user_passwd) = @_;

    my %config = read_conf;
    if (exists $config{$user_name}) {
        $config{$user_name} = $new_user_passwd;
        rewrite_config \%config;
        say "Пользователю $user_name был успешно изменен пароль!";
        return 1;
    }

    say "Пользователю [$user_name] не был изменен пароль т.к. такой пользователь не найден!";
    return 0;
}

sub check_if_help_request() {
    my $help_flag = shift @ARGV;
    return defined $help_flag && $help_flag eq '-h';
}

sub print_help_information() {

    my $multiline_string =
<<'END_OF_STRING';
    ######################################################
    #back_end.pl usage
    #action=reg user_name=NAME user_passwd=PASSWD ./task_12.pl - registaton new user in system;
    #action=log user_name=NAME user_passwd=PASSWD ./task_12.pl - login in system
    #action=del user_name=NAME ./task_12.pl - remove user from system
    #action=change_passwd user_name=NAME user_passwd=PASSWD ./back_end.pl - change user password
    ######################################################
END_OF_STRING

    print $multiline_string;
}

1;