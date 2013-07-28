use rlib;
use Modern::Perl;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use YAML::Syck;

use t::lib::MockTest;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 't::lib::MockTest');
$mech->get_ok('/');
$mech->content_contains('ok');

$mech->get_ok('/auth');
is( Load($mech->content), undef );
$mech->get_ok('/auth?address=172.27.0.18');
ok( Load($mech->content)->{'Common Name'} );

done_testing;
