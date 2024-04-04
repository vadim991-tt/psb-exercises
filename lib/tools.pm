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
    if (exists $user_prms{$user_name}) {
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
    if (exists $user_prms{$user_name}) {
        say "Пользователь с таким никнеймом уже зарегистрирован";
        return 0;
    }

    $user_prms{$user_name} = $user_passwd;
    rewrite_config (\%user_prms);

}

sub get_params_from_env {

    my ($user_name, $user_passwd, $action) = @ENV{ qw /user_name user_passwd action/ };
    unless (defined $user_name && defined $user_passwd) {
        die "Пожалуйста добавьте параметры user_name, user_passwd, action в ENV \n";
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

1;