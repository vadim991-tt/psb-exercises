#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use experimental 'smartmatch';
use v5.10;

# Поддержка файлов
use File::Basename;
use File::Spec;

# Поддержка UTF8
use utf8;
use open qw( :utf8 );
binmode( STDIN, ':utf8' );
binmode( STDOUT, ':utf8' );


# Слова, которые считаются неприличными
my @bad_words = ( "сука", "ебаный", "перл" );


# Функция, проверяющая заканчивается ли строка символом переноса
sub _string_ends_with_next_line {
    my $str = shift;
    return $str =~ /-$/;
}


# Функция, удаляющяя non-alphanumeric символы
sub _beatify_word {
    my $str = shift;
    $str =~ s/[^\w\s\p{IsCyrillic}]//g;
    return $str;
}


# Функция, фильрующая элемент через умное сравнение
sub _filter_bad_word {
    return !( $_ ~~ @bad_words );
}

# Функция, объединяющая файл и директорию
sub _concat_file_with_dir {
    my ( $dir_name, $file_name ) = @_;
    my $new_name = File::Spec->catfile( $dir_name, $file_name );
    return $new_name;
}

sub _process_file {

    my $filename = shift;

    unless ( -f $filename && -e _ ) {
        die "Файл не найден или является директорией \n";
    }

    unless ( open IN, $filename ) {
        die "Невозможно открыть файл'$filename': $!";
    }

    my %dictionary = qw{};
    my $previous_line_word = "";
    foreach my $line ( <IN> ) {

        my @words = split( " ", $line );
        my $should_add_to_result = 1;
        for ( my $i = 0; $i < @words; $i++ ) {

            my $word = $words[$i];

            # Если в прошлой строке нашли перенос строки
            # конкатим подстроку до переноса
            if ( $i == 0 && $previous_line_word ) {
                $word = $previous_line_word . $word;
            }


            # Если слово последнее из строки
            # проверяем на символ переноса
            if ( $i == $#words ) {
                if ( _string_ends_with_next_line( $word ) ) {
                    $previous_line_word = substr( $word, 0, -1 );
                    $should_add_to_result = 0;
                }
                else {
                    $previous_line_word = "";
                }
            }

            # Добавляем слово в коллекцию,
            # предварительно убрав мусор
            if ( $should_add_to_result ) {
                $word = _beatify_word( $word );
                my $current = $dictionary{$word};
                if ( defined $current ) {
                    $dictionary{$word} = $current + 1;
                }
                else {
                    $dictionary{$word} = 1;
                }
            }

        }
    }
    close IN;

    say "$_ => $dictionary{$_}" for ( grep( _filter_bad_word, keys %dictionary ) );

}

my $file_name = $ARGV[0];
unless ( defined $file_name ) {
    die "Пожалуйста, предоставьте имя файла\n";
}

_process_file( _concat_file_with_dir( "/home/vadim/IdeaProjects/psb-exercises/newsletter", $file_name ));
