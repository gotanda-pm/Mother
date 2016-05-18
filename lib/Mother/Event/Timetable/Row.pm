package Mother::Event::Timetable::Row;
use strict;
use warnings;
use 5.14.0;

sub new {
    my ($class, $start_at, $row_data) = @_;
    bless {
        row_data => $row_data,
        start_at => $start_at,
    } => $class;
}

sub start_at { shift->{start_at} }
sub end_at   {
    my $self = shift;
    return $self->{start_at}->plus_minutes($self->{row_data}->{minutes});
}

sub DESTROY {} # no autoload

our $AUTOLOAD;
sub AUTOLOAD {
    my $self = shift;
    my $name = $AUTOLOAD =~ s/^.*://r;
    return $self->{row_data}->{$name};
}

1;
__END__
