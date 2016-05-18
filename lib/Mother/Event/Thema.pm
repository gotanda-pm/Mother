package Mother::Event::Thema;
use strict;
use warnings;

sub new {
    my ($class, $config) = @_;
    bless {
        config => $config,
    } => $class;
}

sub title       { shift->{config}->{title} }
sub description { shift->{config}->{description} }

1;
__END__
