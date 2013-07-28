use rlib;
use Modern::Perl;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use YAML::Syck;

use t::lib::DBICTest;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 't::lib::DBICTest');
$mech->get_ok('/');
$mech->content_contains('ok');

$mech->get_ok('/auth?address=172.27.0.18');
is( Load($mech->content)->{username}, 'foo' );

done_testing;
