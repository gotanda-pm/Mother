package Mother::Event::Sponsor;
use strict;
use warnings;

sub new {
    my ($class, $config) = @_;
    bless {
        config => $config,
    } => $class;
}

sub name { shift->{config}->{name} }
sub url  { shift->{config}->{url}  }

1;
__END__
