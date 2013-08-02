#!/usr/bin/env perl

use Modern::Perl;
use Benchmark qw(:all);

use Net::OpenVPN::Manage;

sub get_hashref1 {
    my $vpn = Net::OpenVPN::Manage->new({ 
        host    => '127.0.0.1',
        port    => '7505',
        timeout => 10,
    });
    $vpn->connect;
    $vpn->status(2);
}

sub get_hashref2 {
    state $vpn = do {
        my $vpn = Net::OpenVPN::Manage->new({ 
            host    => '127.0.0.1',
            port    => '7505',
            timeout => 10,
        });
        $vpn->connect;
        $vpn;
    };
    $vpn->status(2);
}

sub get_hashref3 {
    state $vpn = Net::OpenVPN::Manage->new({ 
        host    => '127.0.0.1',
        port    => '7505',
        timeout => 10,
    });

    $vpn->connect;
    my $ref = $vpn->status(2);
    delete $vpn->{objects}{_telnet_};
    $ref;
}

sub get_hashref4 {
    state $vpn = Net::OpenVPN::Manage->new({ 
        host    => '127.0.0.1',
        port    => '7505',
        timeout => 10,
    });
    $vpn->connect;
    my $ref = $vpn->status(2);
    $vpn->{objects}{_telnet_}->close;
    $ref;
}

sub get_hashref5 {
    state $vpn = Net::OpenVPN::Manage->new({ 
        host    => '127.0.0.1',
        port    => '7505',
        timeout => 10,
    });
    $vpn->{objects}{_telnet_} ? $vpn->{objects}{_telnet_}->open(Host => '127.0.0.1', Port => 7505) : $vpn->connect;
    my $ref = $vpn->status(2);
    $vpn->{objects}{_telnet_}->close;
    $ref;
}

#get_hashref1();
#get_hashref2();
#get_hashref3();
#get_hashref4();
get_hashref5();

my $count = 1000;
timethese($count, {
    #'get_hashref1' => sub { get_hashref1() },
    #'get_hashref2' => sub { get_hashref2() },
    #'get_hashref3' => sub { get_hashref3() },
    #'get_hashref4' => sub { get_hashref4() },
    'get_hashref5' => sub { get_hashref5() },
});
# get_hashref1:  2 wallclock secs ( 0.62 usr +  0.30 sys =  0.93 CPU) @ 1075.63/s (n=1000)
# get_hashref2:  0 wallclock secs ( 0.05 usr +  0.26 sys =  0.30 CPU) @ 3282.05/s (n=1000)
# get_hashref3:  2 wallclock secs ( 0.59 usr +  0.33 sys =  0.91 CPU) @ 1094.02/s (n=1000)
# get_hashref4:  1 wallclock secs ( 0.61 usr +  0.32 sys =  0.93 CPU) @ 1075.63/s (n=1000)
# get_hashref5:  3 wallclock secs ( 0.22 usr +  0.25 sys =  0.47 CPU) @ 2133.33/s (n=1000)
