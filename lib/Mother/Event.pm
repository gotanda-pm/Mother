package Mother::Event;
use strict;
use warnings;

use YAML::Tiny;
use Time::Moment;
use List::Util qw/sum/;

use Mother::Event::Thema;
use Mother::Event::Venue;
use Mother::Event::Party;
use Mother::Event::Sponsor;
use Mother::Event::Timetable;
use Mother::Event::Waitlist;

sub new {
    my ($class, $config) = @_;
    bless {
        config => $config,
    } => $class;
}

sub load {
    my ($class, $file) = @_;
    my $config = YAML::Tiny->read($file)->[0]->{event};
    return $class->new($config);
}

sub id        { shift->{config}->{id}  }
sub url       { shift->{config}->{url} }
sub hashtag   { 'gotandapm' }
sub sub_title { 'http://gotanda.pm.org/' }
sub title     { sprintf 'Gotanda.pm Perl Technology Conference #%d', shift->id }
sub thema     { Mother::Event::Thema->new(shift->{config}->{thema}) }
sub party     { Mother::Event::Party->new(shift->{config}->{party}) }
sub venue     { Mother::Event::Venue->new(shift->{config}->{venue}) }

sub sponsors {
    my $self = shift;
    return [
        map { Mother::Event::Sponsor->new($_) } @{ $self->{config}->{sponsors} }
    ];
}

sub connpass_event_id {
    my $self = shift;
    my ($id) = $self->url =~ m{^https?://gotanda-pm\.connpass\.com/event/([0-9]+)};
    return $id;
}

sub _at {
    my ($self, $name) = @_;
    my $key = "${name}_at";
    my $at = $self->{config}->{date}.'T'.$self->{config}->{$key}.':00+09:00';
    return Time::Moment->from_string($at);
}

sub waitlists {
    my ($self, $type) = @_;
    return Mother::Event::Waitlist->all(
        type      => $type,
        venue     => $self->venue,
        timetable => $self->{config}->{timetable},
    );
}

sub open_at  { shift->_at('open') }
sub start_at { shift->_at('start') }
sub end_at {
    my $self = shift;
    my $start_at = $self->start_at;
    my $minutes = sum map { $_->{minutes} } @{ $self->{config}->{timetable} };
    return $start_at->plus_minutes($minutes);
}

sub timetable {
    my $self = shift;
    return Mother::Event::Timetable->new(
        open_at  => $self->open_at,
        start_at => $self->start_at,
        config   => $self->{config}->{timetable},
    );
}

1;
__END__
