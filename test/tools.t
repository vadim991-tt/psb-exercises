#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use File::Temp qw( tempfile );
use v5.10;
use lib '../lib/';
use tools;

our $user_name;
our $user_pass;

sub _prepare {

    say "### PREPARE FOR TESTING ###";

    $user_name = "user";
    $user_pass = "pass";

    my ( $fh, $filename ) = tempfile();
    unless ( defined $fh ) {
        die "Failed to create a temporary file.";
    }
    print $fh "$user_name=$user_pass\n";
    close $fh;

    $tools::config_path = $filename;

    say "########################\n\n";
}





sub _test_read_config {
    say "### READ CONFIG TESTS ###";

    my $config = tools::read_conf();
    is_deeply
        (
            $config,
            { $user_name => "$user_pass" },
            'Read_conf reads the config correctly'
        );

    say "########################\n\n";

}


sub _test_login {
    say "### LOGIN TEST ###";

    # Test login successful
    ok( tools::login( $user_name, $user_pass ), 'Login successful with correct credentials' );
    # Test login unsuccessful
    ok( !tools::login( "wrong_username", "wrong_password" ), 'Login unsuccessful with incorrect credentials' );
    # Test login with undef creds
    ok( !tools::login( undef, undef ), 'Login fails with undefined credentials' );

    say "########################\n\n";
}

sub _test_register {
    say "### REGISTER TEST ###";

    my $ok_user_result = tools::reg_usr( 'login', 'pass' );
    ok( $ok_user_result, 'Reg_usr fails with missing user details' );

    # Test registration with missing login
    my $missing_user_result = tools::reg_usr( undef, 'pass' );
    ok( !$missing_user_result, 'Reg_usr fails with missing user details' );

    # Test registration with missing pass
    my $missing_pass_result = tools::reg_usr( 'user', undef );
    ok( !$missing_pass_result, 'Reg_usr fails with missing user details' );

    # Test attempt to register an existing user
    my $existing_user_result = tools::reg_usr( "$user_name", 'any_password' );
    ok( !$existing_user_result, 'Reg_usr fails to register an existing user' );

    say "########################\n\n";
}


sub _test_check_user_name {

    say "### CHECK USER NAME TEST ###";
    my $valid_username = tools::check_user_name( "normal_login" );
    ok( $valid_username, 'Check_user_name successful' );

    my $invalid_username = tools::check_user_name( "Кирилица и пробелы" );
    ok( !$invalid_username, 'Check_user_name fails with bad characters' );
    say "########################\n\n";

}


sub _test_check_passwd {

    say "### CHECK PASSWD TEST ###";

    my $valid_pwd = tools::check_user_passwd( "Z\$0123456789ABCDEF" );
    ok( $valid_pwd, 'Check_password successful' );

    my $less_than_8_chars_pwd = tools::check_user_passwd( "1234567" );
    ok( !$less_than_8_chars_pwd, 'Check_password fails less than 8 chars' );

    my $not_starting_with_alphabetic_pwd = tools::check_user_passwd( "\$0123456789ABCDEF" );
    ok( !$not_starting_with_alphabetic_pwd, 'Check_password fails not starting with alphabet' );

    my $no_special_symbol_pwd = tools::check_user_passwd( "Z123456789ABCDEF" );
    ok( !$no_special_symbol_pwd, 'Check_password fails no special symbol' );

    my $no_upper_case_pwd = tools::check_user_passwd( "z\$123456789abcdef" );
    ok( !$no_upper_case_pwd, 'Check_password fails less than 8 chars' );

    my $no_digits_pwd = tools::check_user_passwd( "z\$ABCDEFabcdef" );
    ok( !$no_digits_pwd, 'Check_password fails no digits' );

    say "########################\n\n";

}

sub _test_get_params {

    say "### GET PARAMS FROM ENV TEST ###";

    my @params = eval { tools::get_params_from_env(); };
    ok( !@params, 'Get_params_from_env fails: no params' );

    @ENV{qw( user_name user_passwd action )} = ( 'username', 'test', 'reg' );
    my @params_ok = eval { tools::get_params_from_env(); };
    ok( @params_ok, 'Get_params_from_env success ' );
    delete $ENV{'user_name', 'user_passwd', 'action'};

    say "########################\n\n";
}

sub _test_rewrite_config {

    say "### REWRITE CONFIG TEST ###";

    my $conf = tools::read_conf;
    $conf->{"Vadim"} = "12345";
    tools::rewrite_config( $conf );
    my $new_conf = tools::read_conf;
    ok( $new_conf->{"Vadim"}, "Rewrite_config success" );

    say "########################\n\n";
}

sub _test_delete_user {

    say "### DELETE USER TEST ###";

    tools::reg_usr( 'login', 'pass' );
    ok( tools::delete_user( 'login' ), "Delete user success" );
    ok( !tools::delete_user( 'non_existing_user', "Delete user fails: no such user" ));

    say "########################\n\n";

}

sub _test_change_passwd {
    say "### CHANGE USER PASSWD TEST ###";
    tools::reg_usr( 'login', 'pass' );
    ok( tools::change_passwd( 'login', 'pass' ), "Change password success" );

    ok( !tools::change_passwd( 'non_existing_user', 'non_existing_pass' ), "Change password fails: no such user" );
    say "########################\n\n";
}

sub _test_other_methods {

    say "### OTHER METHODS TEST ###";
    ok( tools::print_help_information, "Print information successful" );
    ok( !tools::check_if_help_request, "Check for help successful" );
    say "########################\n\n";

}

_prepare();

_test_read_config();

_test_login();

_test_register();

_test_check_user_name();

_test_check_passwd();

_test_get_params();

_test_rewrite_config();

_test_delete_user();

_test_change_passwd();

_test_other_methods();


done_testing();

