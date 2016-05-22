package Mother::Event::Timetable;
use strict;
use warnings;

use Mother::Event::Timetable::Row::Entry;
use Mother::Event::Timetable::Row::Announce;
use Mother::Event::Timetable::Row::Talk;
use Mother::Event::Timetable::Row::Break;
use Mother::Event::Timetable::Row::Lt;
use Mother::Event::Timetable::Row::Party;

sub _guess_row_class {
    my $type = shift;
    return 'Mother::Event::Timetable::Row::'.ucfirst $type;
}

sub new {
    my $class = shift;
    bless {@_} => $class;
}

sub rows {
    my $self = shift;

    my @rows = Mother::Event::Timetable::Row::Entry->new($self->{open_at}, {
        minutes => $self->{open_at}->delta_minutes($self->{start_at}),
    });
    for my $row_data (@{ $self->{config} }) {
        my $row_class = _guess_row_class($row_data->{type});
        push @rows => $row_class->new($rows[-1]->end_at, $row_data);
    }
    return wantarray ? @rows : \@rows;
}

1;
__END__
