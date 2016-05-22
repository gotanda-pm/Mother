package Mother::Event::Waitlist;
use strict;
use warnings;
use utf8;

use List::UtilsBy qw/partition_by/;

sub all {
    my ($class, %args) = @_;
    my @timetable = grep { $_->{type} eq $args{type} } @{ $args{timetable} };
    if ($args{type} eq 'talk' || $args{type} eq 'lt') {
        my %timetable = partition_by { $_->{minutes} } @timetable;
        return map {
            my $name = $args{type} eq 'talk' ? sprintf('スピーカー枠(%dmin)', $_)
                     : $args{type} eq 'lt'   ? sprintf('LT枠(%dmin)', $_)
                     : die "Unknown type: $args{type}";
            my $capacity = scalar @{$timetable{$_}};
            $class->new(
                name     => $name,
                capacity => $capacity,
            )
        } keys %timetable;
    }
    elsif ($args{type} eq 'normal') {
        my $speakers = grep { $_->{type} eq 'talk' || $_->{type} eq 'lt' } @{ $args{timetable} };
        return $class->new(
            name     => '一般枠',
            capacity => $args{venue}->capacity - $speakers,
        );
    }
    die "Unknown type: $args{type}";
}

sub new {
    my $class = shift;
    bless {@_} => $class;
}

sub name     { shift->{name}     }
sub capacity { shift->{capacity} }

1;
__END__
