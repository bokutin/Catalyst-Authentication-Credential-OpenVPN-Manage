package t::lib::ConnectTest::Controller::Root;

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
    $c->res->body( Dump $user );
}

1;
