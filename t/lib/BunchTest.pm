package t::lib::BunchTest;

use Moose;
extends qw(Catalyst);

use YAML::Syck;

__PACKAGE__->config(
    'Model::DBIC' => {
        schema_class => 't::lib::DBICTest::Schema',
        connect_info => {
            dsn => 'dbi:SQLite::memory:',
            RaiseError     => 1,
            sqlite_unicode => 1,
            on_connect_call => sub {
                my ($storage) = @_;
                my $schema = $storage->schema;
                $schema->deploy;
                $schema->resultset('User')->create({ id => 1, username => 'foo', password => 'secret', openvpn_cn => '05' });
                $schema->resultset('User')->create({ id => 2, username => 'bar', password => 'secret', openvpn_cn => '78' });
            },
        },
    },
    'Plugin::Authentication' => {
        default_realm => 'bunch',
        realms => {
            bunch => {
                class => 'Progressive',
                realms => [qw(openvpn_udp openvpn_tcp)],
            },
            openvpn_udp => {
                credential => {
                    class => 'OpenVPN::Manage',
                    host  => '127.0.0.1',
                    port  => '7505',
                    server_status_mock_yaml => 't/data/openvpn/udp_status_ref',
                },
                store => {
                    class => 'DBIx::Class',
                    user_model => 'DBIC::User',
                },
                class => 'Adaptor',
                store_adaptor => {
                    method => 'code',
                    code => sub {
                        my ($realmname, $original_authinfo, $hashref_to_config ) = @_;
                        my $newauthinfo = { openvpn_cn => $original_authinfo->{'Common Name'} };
                        return $newauthinfo;
                    },
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
                    class => 'DBIx::Class',
                    user_model => 'DBIC::User',
                },
                class => 'Adaptor',
                store_adaptor => {
                    method => 'code',
                    code => sub {
                        my ($realmname, $original_authinfo, $hashref_to_config ) = @_;
                        my $newauthinfo = { openvpn_cn => $original_authinfo->{'Common Name'} };
                        return $newauthinfo;
                    },
                },
            },
        },
    },
);

__PACKAGE__->setup(
    'Authentication'
);

1;
