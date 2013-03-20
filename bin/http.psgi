#!/usr/bin/perl
use strict;
use warnings;

use charnames qw(:full);
use lib::abs qw(../lib);
use open qw(:std :utf8);

use Cwd qw(abs_path);
use File::Spec;
use Plack::Request;
use YAML;

use Eve::Registry;
use Eve::Event::PsgiRequestReceived;

use HelloWorldHttpResource;

=head1 NAME

B<http.psgi> - the main PSGI-application script.

=head1 DESCRIPTION

B<http.psgi> is the PSGI app script that is the main entry point of
the web-service. It is used by the C<Plack::Handler> that is an
adapter between the server and this application.

This script defines and returns a handler subroutine that will accept
HTTP request events from the HTTP server.

=cut

sub init {
    my $dirname = File::Basename::dirname(__FILE__);
    my $file_path = File::Spec->catfile($dirname, '../etc/helloworld.yaml');

    my $registry = Eve::Registry->new(%{
        YAML::LoadFile(
            Eve::Support::open(mode => '<', file => $file_path))});

    $registry->bind_http_event_handlers();

    # Bind actual page controllers
    $registry->get_http_dispatcher()->bind(
        name => 'main',
        pattern => '/',
        resource_constructor => sub {
            # By convention creating new objects is only allowed
            # inside the registry methods, but for the sake of
            # demostration we create a resource object right here
            return HelloWorldHttpResource->new(
                %{$registry->_get_http_resource_parameter_list()});
        });

    return sub {
        my $env = shift;

        $env->{'SCRIPT_NAME'} = substr($env->{'SCRIPT_NAME'}, 4);

        my $event = Eve::Event::PsgiRequestReceived->new(
            env_hash => $env,
            event_map => $registry->get_event_map());

        chdir($registry->working_dir_string);

        $event->trigger();

        return $event->response->get_raw_list();
    };
}


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Igor Zinovyev.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

init();
