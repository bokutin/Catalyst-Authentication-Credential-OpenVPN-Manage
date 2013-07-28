use rlib;
use Modern::Perl;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use Net::EmptyPort qw(check_port);
use YAML::Syck;

use t::lib::ConnectTest;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 't::lib::ConnectTest');
$mech->get_ok('/');
$mech->content_contains('ok');

my @logs;
$mech->catalyst_app->log->meta->make_mutable->add_around_method_modifier('_send_to_log' => sub {
    my $orig = shift;
    my $self = shift;
    push @logs, @_;
});

is( @logs, 0 );

$mech->get_ok('/auth');
is( Load($mech->content), undef );

is( @logs, 1 );
if (check_port(7505)) {
    like( $logs[0], qr/OpenVPN Management Port connection succeeded/ );
}
else {
    like( $logs[0], qr/OpenVPN Management Port connection failed/ );
}

done_testing;
