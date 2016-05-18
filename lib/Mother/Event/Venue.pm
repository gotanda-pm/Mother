package Mother::Event::Venue;
use strict;
use warnings;

sub new {
    my ($class, $config) = @_;
    bless {
        config => $config,
    } => $class;
}

sub name    { shift->{config}->{name}    }
sub address { shift->{config}->{address} }

1;
__END__
