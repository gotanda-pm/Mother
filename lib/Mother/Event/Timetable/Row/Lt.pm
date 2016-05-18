package Mother::Event::Timetable::Row::Lt;
use strict;
use warnings;
use utf8;

use parent qw/Mother::Event::Timetable::Row/;

sub title { 'LT: '.shift->speaker }
sub description { shift->detail }

1;
__END__
