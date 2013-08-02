package Catalyst::Authentication::Credential::OpenVPN::Manage;

use strict;
use warnings;

use Data::Rmap;
use Net::OpenVPN::Manage;
use YAML::Syck;

use constant { IDX_VIRT_ADDR => 2 };

sub new {
    my ($class, $config, $app, $realm) = @_;

    my $self = bless { %$config }, $class;
}

sub authenticate {
    my ($self, $c, $realm, $authinfo_orig) = @_;

    my $ref = $self->openvpn_server_status($c) or return;

    my $authinfo = { %$authinfo_orig };
    my $addr = $authinfo->{address} ||= $c->req->address;

    for (@{ $ref->{CLIENT_LIST} }) {
        if ($_->[IDX_VIRT_ADDR] eq $addr) {
            @$authinfo{ @{$ref->{HEADER}{CLIENT_LIST}} } = @$_;
            return my $user_obj = $realm->find_user($authinfo, $c);
        }
    }

    return;
}

sub openvpn_server_status {
    my ($self, $c) = @_;

    if ($self->{server_status_mock_yaml}) {
        return LoadFile( $self->{server_status_mock_yaml} );
    }

    my $vpn = $self->vpn($c) or return;

    my $ref = $vpn->status_ref;
    rmap { chomp } $ref; # chomp tailing \n.
    $ref;
}

sub vpn {
    my ($self, $c) = @_;

    my $vpn = Net::OpenVPN::Manage->new({ 
        host    => $self->{host},
        port    => $self->{port},
        timeout => $self->{timeout} || 5,
    });

    if ($vpn->connect) {
        $c->log->debug( "OpenVPN Management Port connection succeeded. (@{[ $self->{host} ]}:@{[ $self->{port} ]})" );
        $vpn;
    }
    else {
        $c->log->fatal( "OpenVPN Management Port connection failed. (@{[ $self->{host} ]}:@{[ $self->{port} ]})" );
        undef;
    }
}

1;
