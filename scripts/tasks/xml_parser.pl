#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use Data::Dumper;
use v5.10;

# Создаём парсер
my $xml = XML::LibXML->new();
$xml->load_ext_dtd(0);          # Отключаем загрузку других сущностей (XXE)
$xml->no_network(1);            # Отключаем подгрузку из интернета (XXE)

# Создаём объект xml схемы для валидации
my $xsd_location = "./files/user.xsd";
my $schema = XML::LibXML::Schema->new(location => $xsd_location);


# Получаем входящий файл
my $filename = $ARGV[0];
if ( !( defined $filename && $filename ne '' ) ) {
    die "Введите имя файла!\n";
}


# Парсим документ
my $document;
eval {
    $document = $xml->parse_file($filename);
};
if ($@) {
    die "Ошибка при чтении XML файла: $@\n";
}


# Пытаемся валидировать XML документ
say "Приступаем к валидации объекта...";
eval { $schema->validate($document) };
if ($@) {
    die "Валидация не удалась: $@";
} else {
    say "Валидация успешна. Переходим к распечатыванию объекта";
}


# Выводим содержимое XML документа
print "XML Документ:\n", $document->toString(1), "\n";


