package Mother::Event::Party;
use strict;
use warnings;

sub new {
    my ($class, $config) = @_;
    bless {
        config => $config,
    } => $class;
}

sub venue { shift->{config}->{venue} }
sub fee   { shift->{config}->{fee}   }

1;
__END__
