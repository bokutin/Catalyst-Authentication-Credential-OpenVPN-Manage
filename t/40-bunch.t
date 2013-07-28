use rlib;
use Modern::Perl;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use YAML::Syck;

use t::lib::BunchTest;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 't::lib::BunchTest');

$mech->get_ok('/');
$mech->content_contains('ok');

$mech->get_ok('/auth');
is( Load($mech->content), undef );

$mech->get_ok('/auth?address=172.27.0.18'); # udp
is( Load($mech->content)->{username}, 'foo' );

$mech->get_ok('/auth?address=172.29.1.38'); # tcp
is( Load($mech->content)->{username}, 'bar' );

$mech->get_ok('/status'); # udp & tcp
my @status = @{ Load($mech->content) };
ok( grep { $_->[2] eq '172.27.0.18' } @status ); # udp
ok( grep { $_->[2] eq '172.29.1.38' } @status ); # tcp

done_testing;
