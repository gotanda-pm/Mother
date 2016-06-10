package Mother::Connpass;
use strict;
use warnings;

use Config::Identity;
use Carp;
use Cwd;

my @REQUIRED = qw/username password/;

sub load {
    my $class = shift;
    my @base = -f '.connpass' ? Cwd::getcwd() : ();

    my $path = Config::Identity->best(connpass => @base);
    die '.connpass is not found' unless $path;

    my %identity = Config::Identity->load($path);
    return _check(%identity);
}

sub _check {
    my %identity = @_;

    my @missing;
    defined $identity{$_} && length $identity{$_}
        or push @missing, $_ for @REQUIRED;
    if (@missing) {
        local $Carp::CarpLevel = $Carp::CarpLevel + 1;
        croak "Missing ", join ' and ', @missing
    }

    return %identity;
}

1;
__END__
