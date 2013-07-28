package t::lib::BunchTest::Schema::Result::User;
use strict;
use base qw(DBIx::Class::Core);

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    id         => { data_type => 'integer', is_nullable => 0, is_auto_increment => 1 },
    username   => { data_type => 'varchar', is_nullable => 0 },
    password   => { data_type => 'varchar', is_nullable => 0 },
    openvpn_cn => { data_type => 'varchar', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');

1;
