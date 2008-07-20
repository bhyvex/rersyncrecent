use Test::More;
my $tests;
BEGIN { $tests = 0 }
use lib "lib";
use File::Basename qw(dirname);
use File::Copy qw(cp);
use File::Path qw(mkpath rmtree);
use File::Rsync::Mirror::Recentfile;
use Time::HiRes qw(time);

my $root_from = "t/ta";
my $root_to = "t/tb";

{
    BEGIN { $tests += 1 }
    my $rf = File::Rsync::Mirror::Recentfile->new_from_file("t/RECENT-6h.yaml");
    my $recent_events = $rf->recent_events;
    is(56, scalar @$recent_events, "found $recent_events events");
    for my $e (@$recent_events) {
        my $file_from = sprintf "%s/%s", $root_from, $e->{path};
        mkpath dirname $file_from;
        open my $fh, ">", $file_from or die "Could not open '$file_from': $!";
        print $fh time, ":", $file_from, "\n";
        close $fh or die "Could not close '$file_from': $!";
    }
    cp "t/RECENT-6h.yaml", "t/ta/RECENT-6h.yaml" or die "Could not cp: $!";
}

{
    BEGIN { $tests += 1 }
    my $rf = File::Rsync::Mirror::Recentfile->new
        (
         filenameroot => "RECENT",
         interval => q(6h),
         remote_dir => $root_from,
         localroot => $root_to,
         rsync_options => {
                           compress => 0,
                           'rsync-path' => '/usr/bin/rsync',
                           links => 1,
                           times => 1,
                           'omit-dir-times' => 1,
                           checksum => 0,
                          },
         verbose => 1,
        );
    my $success = $rf->mirror;
    ok($success, "mirrored with success");
}

rmtree [$root_from, $root_to];

BEGIN { plan tests => $tests }

# Local Variables:
# mode: cperl
# cperl-indent-level: 4
# End:
