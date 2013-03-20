# -*- mode: Perl; -*-
package RegistryTest;

use parent qw(Eve::Test);

use strict;
use warnings;

use File::Basename ();
use File::Spec ();

use Test::More;

use Eve::RegistryStub;

use HelloWorld::Registry;

sub setup : Test(setup) {
    my $self = shift;

    $self->{'registry'} = HelloWorld::Registry->new();
}

sub test_isa_registry: Test {
    my $self = shift;

    isa_ok(
        $self->{'registry'},
        'Eve::Registry',
        'The registry object should be derived from the main Registry class');
}

1;
