#!/usr/bin/env perl

use Atto qw(hello);

sub hello {
    my $name = shift // "world";
    return "hello $name";
}

Atto->psgi;
