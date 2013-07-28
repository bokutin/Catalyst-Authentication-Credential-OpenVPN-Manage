package t::lib::BunchTest::Controller::Root;

use Moose;
BEGIN { extends qw(Catalyst::Controller) }

use YAML::Syck;

__PACKAGE__->config( namespace => '' );

sub index :Path {
    my ($self, $c) = @_;

    $c->res->body('ok');
}

sub auth :Local {
    my ($self, $c) = @_;

    my $address = $c->req->params->{address} || $c->req->address;

    my $user = $c->authenticate({ address => $address });
    $c->res->body( Dump ( $user ? { $user->get_columns } : undef ) );
}

sub status :Local {
    my ($self, $c) = @_;

    my @union;
    for (qw(openvpn_udp openvpn_tcp)) {
        my $realm = $c->get_auth_realm($_);
        my $status_ref = $realm->credential->openvpn_server_status($c);
        push @union, @{$status_ref->{CLIENT_LIST}};
    }
    $c->res->body( Dump \@union );
}

1;
