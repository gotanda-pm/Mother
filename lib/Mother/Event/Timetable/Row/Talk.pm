package Mother::Event::Timetable::Row::Talk;
use strict;
use warnings;
use utf8;

use parent qw/Mother::Event::Timetable::Row/;

sub title { 'Talk: '.shift->speaker }
sub description { shift->detail }

1;
__END__
