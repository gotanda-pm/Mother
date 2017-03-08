use strict;
use warnings;
use utf8;

use Text::Xslate;
use List::Util qw/first/;

use Mother;
use Mother::Event;
use Mother::Connpass;
use WWW::Connpass;
use WWW::Connpass::Event::Waitlist::Fcfs;
use WWW::Connpass::Event::Question::FreeText;
use WWW::Connpass::Event::Question::Radio;

my $event = Mother::Event->load('config/event.yaml');
my $tx = Text::Xslate->new(
    path  => ['template'],
    cache => 0,
);
my $markdown = $tx->render("event/connpass.tx" => {
    event => $event,
});

my %user_info = Mother::Connpass->load();
my $connpass = WWW::Connpass->new();
my $session = $connpass->login(@user_info{qw/username password/});

my $place = first { $_->name eq $event->venue->name } $session->fetch_all_places();
unless (defined $place) {
    $place = $session->register_place(
        name    => $event->venue->name,
        address => $event->venue->address,
        url     => $event->venue->url,
    );
}

my $group = first { $_->name eq 'gotanda-pm' } $session->fetch_organized_groups();
unless (defined $group) {
    die "Cannot find gotanda-pm group.";
}

my $connpass_event = $event->connpass_event_id ? $session->fetch_event_by_id($event->connpass_event_id) : undef;
$connpass_event = $session->new_event($event->title, { group => $group }) unless defined $connpass_event;
if ($connpass_event->title ne $event->title) {
    die "Invalid url: ", $connpass_event->public_url;
}
$connpass_event = $connpass_event->set_place($place)->edit(
    hashtag           => $event->hashtag,
    owner_text        => 'Gotanda.pm',
    sub_title         => $event->sub_title,
    open_end_datetime => $event->open_at->strftime('%Y-%m-%dT%H:%M:%S'),
    start_datetime    => $event->start_at->strftime('%Y-%m-%dT%H:%M:%S'),
    end_datetime      => $event->end_at->strftime('%Y-%m-%dT%H:%M:%S'),
    description_input => $markdown,
);

if ($connpass_event->questionnaire->is_new) {
    $connpass_event->questionnaire->update_questions(
        WWW::Connpass::Event::Question::Radio->new(
            title        => sprintf('懇親会への参加を希望しますか？(参加費:%d円/予定/会場払い)', $event->party->fee),
            answer_frame => [qw/参加する 参加しない/],
            required     => 1,
        ),
        WWW::Connpass::Event::Question::FreeText->new(
            title => 'Talk/LTを行う方はトークタイトル/テーマ等をご記入ください。(仮で結構です/なるべくご記入ください)',
        ),
        WWW::Connpass::Event::Question::FreeText->new(
            title => 'その他、質問/要望/提案などあればご記入ください。',
        ),
    );
}

if (!$event->connpass_event_id) {
    $connpass_event = $connpass_event->refetch()->update_waitlist_count(
        map {
            WWW::Connpass::Event::Waitlist::Fcfs->new(
                name             => $_->name,
                max_participants => $_->capacity,
                join_fee         => '',
                place_fee        => 0,
            ),
        } map { $event->waitlists($_) } qw/talk lt normal/
    );

    my %owners_map = map { $_->username => $_ } $connpass_event->owners;
    my @user = map { $session->search_users_by_name($_) } grep { !$owners_map{$_} } qw/karupanerura papix kfly8/;
    for my $user (@user) {
        $connpass_event->add_owner($user);
    }

    my $url = $connpass_event->public_url;
    system $^X, '-i', '-pe', 's!^  url:.*$!  url: '.$url.'!', 'config/event.yaml';
}
