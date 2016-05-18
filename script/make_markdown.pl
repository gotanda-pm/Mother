use strict;
use warnings;

use Encode;
use Text::Xslate;

use Mother;
use Mother::Event;

my $type = shift @ARGV
    or die "Usage: $0 type";

my $event = Mother::Event->load('config/event.yaml');
my $tx = Text::Xslate->new(
    path  => ['template'],
    cache => 0,
);
my $markdown = $tx->render("event/$type.tx" => {
    event => $event,
});

print Encode::encode_utf8 $markdown;
