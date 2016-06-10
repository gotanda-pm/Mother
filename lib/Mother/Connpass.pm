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
    my %identity = Config::Identity->try_best(connpass => @base);
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
