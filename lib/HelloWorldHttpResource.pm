package HelloWorldHttpResource;

use parent qw(Eve::HttpResource);

use strict;
use warnings;

=head1 NAME

B<HelloWorldHtttpResource> - an example resource class.

=head1 SYNOPSIS

    use HelloWorldHtttpResource;

    # Bind it to an URL using the HTTP resource dispatcher. See
    # B<Eve::HttpDispatcher> class.

=head1 DESCRIPTION

B<HelloWorldHtttpResource> is just a sample HTTP resource
class producing some output.

=head1 METHODS

=head2 B<_get()>

=cut

sub _get {
    my $self = shift;

    $self->_response->set_header(name => "Content-type", value => "text/plain");
    $self->_response->set_body(text => "Hello world!");

    return;
}

=head1 SEE ALSO

=over 4

=item L<Eve::Class>

=item L<Eve::HttpDispatcher>

=item L<Eve::HttpResource>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Igor Zinovyev.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1;
