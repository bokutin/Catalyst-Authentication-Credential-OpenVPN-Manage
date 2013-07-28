package t::lib::MockTest;

use Moose;
extends qw(Catalyst);

__PACKAGE__->config(
    'Plugin::Authentication' => {
        default_realm => 'openvpn_udp',
        realms => {
            openvpn_udp => {
                credential => {
                    class => 'OpenVPN::Manage',
                    host  => '127.0.0.1',
                    port  => '7505',
                    server_status_mock_yaml => 't/data/openvpn/udp_status_ref',
                },
                store => {
                    class => 'Null',
                },
            },
            openvpn_tcp => {
                credential => {
                    class => 'OpenVPN::Manage',
                    host  => '127.0.0.1',
                    port  => '7506',
                    server_status_mock_yaml => 't/data/openvpn/tcp_status_ref',
                },
                store => {
                    class => 'Null',
                },
            },
        },
    },
);

__PACKAGE__->setup(
    'Authentication'
);

1;
