use strict;
use warnings;
{
    package other;
    use Import::Box -as => 't2', 'Test2::Tools::Basic' => [qw/ok done_testing/];
    use Import::Box -as => 't2', 'Test2::Tools::Compare' => [qw/like is/];
    use Import::Box(
        -as => 't2',
        'Test2::Tools::Exception' => [qw/dies/],
        'Test2::Tools::Warnings' => [qw/warns/],
    );

    t2->ok(1, "ok works in 'other'");
    t2 note => "note works in 'other' meaning stash is shared";
}

use Import::Box -as => 't2', -from => 'other', 'Test2::Tools::Basic' => [qw/note/];

t2->ok(1, "ok works in 'main'");

t2 is => ('a', 'a', 'is works');

t2 like => (
    'foo bar baz',
    qr/bar/,
    "like works"
);

t2->ok(
    !t2->warns(sub {
        t2->like(
            t2->dies(sub {die "this is an error xxx"}),
            qr/this is an error xxx/,
            "Called tool that takes code block prototype"
        ),
    }),
    "No warnings"
);

t2 note => "done_testing is next";
t2->done_testing;
