package File::Rsync::Mirror::Recent;

# use warnings;
use strict;

=encoding utf-8

=head1 NAME

File::Rsync::Mirror::Recent - mirroring via rsync made efficient

=head1 VERSION

Version 0.0.1

=cut

package File::Rsync::Mirror::Recent;

use Data::Serializer;
use File::Basename qw(dirname fileparse);
use File::Copy qw(cp);
use File::Path qw(mkpath);
use File::Rsync;
use File::Temp;
use List::Util qw(first);
use Scalar::Util qw(reftype);
use Storable;
use Time::HiRes qw();
use YAML::Syck;

use version; our $VERSION = qv('0.0.1');

=head1 SYNOPSIS

B<!!!! PRE-ALPHA ALERT !!!!>

Nothing in here is believed to be stable, nothing yet intended for
public consumption. The plan is to provide a script in one of the next
releases that acts as a frontend for all the backend functionality.
Option and method names will very likely change.

File::Rsync::Mirror::Recent is acting at a higher level than
File::Rsync::Mirror::Recentfile. File::Rsync::Mirror::Recent
establishes a view on a collection of recentfile objects and provides
abstractions spanning multiple intervals associated with those.

B<Unimplemented as of yet>. Will need to shift some accessors from
recentfile to recent.

Reader/mirrorer:

    my $rr = File::Rsync::Mirror::Recent->new
      (
       ignore_link_stat_errors => 1,
       localroot => "/home/ftp/pub/PAUSE/authors",
       remote => "pause.perl.org::authors/RECENT.recent",
       rsync_options => {
                         compress => 1,
                         'rsync-path' => '/usr/bin/rsync',
                         links => 1,
                         times => 1,
                         'omit-dir-times' => 1,
                         checksum => 1,
                        },
       verbose => 1,
      );
    $rr->rmirror;

=head1 EXPORT

No exports.

=head1 CONSTRUCTORS

=head2 my $obj = CLASS->new(%hash)

Constructor. On every argument pair the key is a method name and the
value is an argument to that method name.

=cut

sub new {
    my($class, @args) = @_;
    my $self = bless {}, $class;
    while (@args) {
        my($method,$arg) = splice @args, 0, 2;
        $self->$method($arg);
    }
    return $self;
}

=head1 ACCESSORS

=cut

my @accessors;

BEGIN {
    @accessors = (
                  "_rsync",
                 );

    my @pod_lines =
        split /\n/, <<'=cut'; push @accessors, grep {s/^=item\s+//} @pod_lines; }

=over 4

=item loopinterval

When mirror_loop is called, this accessor can specify how much time
every loop shall at least take. If the work of a loop is done before
that time has gone, sleeps for the rest of the time. Defaults to
arbitrary 42 seconds.

=item max_files_per_connection

Maximum number of files that are transferred on a single rsync call.
Setting it higher means higher performance at the price of holding
connections longer and potentially disturbing other users in the pool.
Defaults to the arbitrary value 42.

=item remote

Rsync address of the remote recentfile. Maybe a symlink.

=item rsync_options

Things like compress, links, times or checksums. Passed in to the
File::Rsync object used to run the mirror.

=item verbose

Boolean to turn on a bit verbosity.

=back

=cut

use accessors @accessors;

=head1 METHODS

=head2 $success = $obj->rmirror ( %options )

Mirrors all recentfiles of the I<remote> address and works through all
of them.

=cut

sub rmirror {
    my($self, %options) = @_;

    # get the remote
    # while it is a symlink, resolve it
    # get all recentfiles
    # loop somehow
    die "FIXME";
}

=head2 (void) $obj->rmirror_loop

Run rmirror in an endless loop.

=cut

sub rmirror_loop {
    my($self) = @_;
    die "FIXME";
}

=head1 AUTHOR

Andreas König

=head1 BUGS

Please report any bugs or feature requests through the web interface
at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=File-Rsync-Mirror-Recent>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc File::Rsync::Mirror::Recent

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=File-Rsync-Mirror-Recent>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/File-Rsync-Mirror-Recent>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/File-Rsync-Mirror-Recent>

=item * Search CPAN

L<http://search.cpan.org/dist/File-Rsync-Mirror-Recent>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to RJBS for module-starter.

=head1 COPYRIGHT & LICENSE

Copyright 2008 Andreas König, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of File::Rsync::Mirror::Recent