#!/bin/perl

=head1 NAME

 RabbitMQ_Connections.pl

=head1 SYNOPSIS

 IntroscopeEPAgent.properties configuration

 introscope.epagent.plugins.stateless.names=CONNECTIONS
 introscope.epagent.stateless.CONNECTIONS.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Connections.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
 introscope.epagent.stateless.CONNECTIONS.delayInSeconds=15

=head1 DESCRIPTION

 Pulls statistics about connections

 To see help information:

 perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Connections.pl --help

 or run with no commandline arguments.

 To test against sample output, use the DEBUG flag:

 perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Connections.pl --debug

=head1 CAVEATS

 For Windows users, please use foward slash "/" as a path separator.
 If directory names have spaces, use the 8.3 format/shortname instead.
 Type "dir /x" from a command prompt to see the shortnames.

 IMPORTANT!! Place a copy of rabbitmqadmin.py in the same location as this plug-in.

=head1 AUTHOR

 Hiko Davis, Principal Services Consultant, CA Technologies

=head1 COPYRIGHT

 Copyright (c) 2014

 This plug-in is provided AS-IS, with no warranties, so please test thoroughly!

=cut

use strict;
use warnings;

use FindBin;
use lib ("$FindBin::Bin", "$FindBin::Bin/lib/perl", "$FindBin::Bin/../lib/perl");
use Wily::PrintMetric;

use Getopt::Long;
use File::Spec;
use Cwd qw(abs_path);
use File::Slurp qw(read_file);

=head2 SUBROUTINES

=cut

=head3 USAGE

 Prints help information for this program

=cut

sub usage {
    print "Unknown option: @_\n" if ( @_ );
    print "usage: $0 [--host=HOST] [--port=PORT] [--user=USERNAME] [--pswd=PASSWORD] [--help|-?]\n";
    exit;
}

my ($help, $rmqHost, $rmqPort, $rmqUser, $rmqPswd, $debug);

# get commandline parameters or display help
&usage if ( @ARGV < 1 or
    not GetOptions( 'help|?'  =>  \$help,
                    'host=s'  =>  \$rmqHost,
                    'port=i'  =>  \$rmqPort,
                    'user=s'  =>  \$rmqUser,
                    'pswd=s'  =>  \$rmqPswd,
                    'debug!'  =>  \$debug,
                  )
    or defined $help );

my (@arrayResults, $execCommand, $rabbitmqadmin);

if ($debug) {
    # read in the test output file; adjust path as needed for your environment
    #@arrayResults = do { open my $fh, '<', File::Spec->catfile(abs_path, "epaplugins", "RabbitMQ", "samples", "connections.txt"); <$fh>; }
    # if you do not have File::Slurp installed, remove the "use" reference, comment out the next line, and uncommment the previous line
    @arrayResults = read_file(File::Spec->catfile(abs_path, "samples", "connections_37.txt"));
} else {
    # determine path to rabbitmqadmin.py; adjust path as needed for your environment
    $rabbitmqadmin = File::Spec->catfile(abs_path, "data", "rabbitmqadmin.py");
    # command to execute rabbitmqadmin.py
    $execCommand="python $rabbitmqadmin --host=$rmqHost --port=$rmqPort --username=$rmqUser --password=$rmqPswd --format=tsv list connections";
    # execute command, place results into array
    @arrayResults=`$execCommand`;
}


# skip first row; iterate through results
for my $i ( 1..$#arrayResults ) {
    # removing trailing newline
    chomp $arrayResults[$i];
    # split on tab "\t"
    my @results = split('\t', $arrayResults[$i]);
    # check @results for empty string & replace with "Unknown"
    foreach ( @results ) {
        if ( length($_) == 0 ) { $_ = "Unknown"; }
    }
    # return results; use "name" column as subresource
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'vhost',
#                                    'value'         =>  $results[0],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'type',
#                                    'value'         =>  $results[2],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'auth_mechanism',
#                                    'value'         =>  $results[3],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'channels',
#                                    'value'         =>  $results[4],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'frame_max',
#                                    'value'         =>  $results[5],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'host',
#                                    'value'         =>  $results[6],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'last_blocked_age',
#                                    'value'         =>  $results[7],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'last_blocked_by',
#                                    'value'         =>  $results[8],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'node',
#                                    'value'         =>  $results[9],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'peer_cert_issuer',
#                                    'value'         =>  $results[10],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'peer_cert_subject',
#                                    'value'         =>  $results[11],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'peer_cert_validity',
#                                    'value'         =>  $results[12],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'peer_host',
#                                    'value'         =>  $results[13],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'peer_port',
#                                    'value'         =>  $results[14],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'port',
#                                    'value'         =>  $results[15],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'protocol',
#                                    'value'         =>  $results[16],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'recv_cnt',
#                                    'value'         =>  $results[17],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'recv_oct',
#                                    'value'         =>  $results[18],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'send_cnt',
#                                    'value'         =>  $results[19],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'send_oct',
#                                    'value'         =>  $results[20],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'send_pend',
#                                    'value'         =>  $results[21],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'ssl',
#                                    'value'         =>  $results[22],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'ssl_cypher',
#                                    'value'         =>  $results[23],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'ssl_hash',
#                                    'value'         =>  $results[24],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'ssl_key_exchange',
#                                    'value'         =>  $results[25],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'ssl_protocol',
#                                    'value'         =>  $results[26],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'state',
#                                    'value'         =>  $results[27],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Connections',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'timeout',
#                                    'value'         =>  $results[28],
#                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Connections',
                                    'subresource'   =>  $results[0] . " -> " . $results[1],
                                    'name'          =>  'user',
                                    'value'         =>  $results[2],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Connections',
                                    'subresource'   =>  $results[0] . " -> " . $results[1],
                                    'name'          =>  'channels',
                                    'value'         =>  $results[3],
                                  );
}
