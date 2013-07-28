use Modern::Perl;

use IO::All;
use Net::OpenVPN::Manage;
use YAML::Syck;

{
    my $vpn = Net::OpenVPN::Manage->new({ 
        host => '127.0.0.1',
        port => '7505',
    });

    die unless $vpn->content;

    io('udp_status1')   ->print( Dump $vpn->status(1)  );
    io('udp_status2')   ->print( Dump $vpn->status(2)  );
    io('udp_status_ref')->print( Dump $vpn->status_ref );
}

{
    my $vpn = Net::OpenVPN::Manage->new({ 
        host => '127.0.0.1',
        port => '7506',
    });

    die unless $vpn->content;

    io('tcp_status1')   ->print( Dump $vpn->status(1)  );
    io('tcp_status2')   ->print( Dump $vpn->status(2)  );
    io('tcp_status_ref')->print( Dump $vpn->status_ref );
}
