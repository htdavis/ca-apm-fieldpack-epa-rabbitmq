#!/bin/perl

=head1 NAME

 RabbitMQ_Channels.pl

=head1 SYNOPSIS

 IntroscopeEPAgent.properties configuration

 introscope.epagent.plugins.stateless.names=CHANNELS
 introscope.epagent.stateless.CHANNELS.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Channels.pl --host=HOST_OR_IP_ADDR --port=12345 --user=USERNAME --pswd=PASSWORD
 introscope.epagent.stateless.CHANNELS.delayInSeconds=15

=head1 DESCRIPTION

 Pulls statistics about channels

 To see help information:

 perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Channels.pl --help

 or run with no commandline arguments.

 To test against sample output, use the DEBUG flag:

 perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Channels.pl --debug

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
    #@arrayResults = do { open my $fh, '<', File::Spec->catfile(abs_path, "epaplugins", "RabbitMQ", "samples", "channels.txt"); <$fh>; }
    # if you do not have File::Slurp installed, remove the "use" reference, comment out the next line, and uncommment the previous line
    @arrayResults = read_file(File::Spec->catfile("samples", "channels_37.txt"));
} else {
    # determine path to rabbitmqadmin.py; adjust path as needed for your environment
    $rabbitmqadmin = File::Spec->catfile(abs_path, "epaplugins", "RabbitMQ", "rabbitmqadmin.py");
    # command to execute rabbitmqadmin.py
    $execCommand="python $rabbitmqadmin --host=$rmqHost --port=$rmqPort --username=$rmqUser --password=$rmqPswd --format=tsv list channels";
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
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Channels',
                                    'subresource'   =>  $results[0] . " -> " . $results[1],
                                    'name'          =>  'user',
                                    'value'         =>  $results[3],
                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'name',
#                                    'value'         =>  $results[2],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'client_flow_blocked',
#                                    'value'         =>  $results[3],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'confirm',
#                                    'value'         =>  $results[4],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'consumer_count',
#                                    'value'         =>  $results[5],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'idle_since',
#                                    'value'         =>  $results[6],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'messages_unacknowledged',
#                                    'value'         =>  $results[7],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'messages_uncommitted',
#                                    'value'         =>  $results[8],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'messages_unconfirmed',
#                                    'value'         =>  $results[9],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'node',
#                                    'value'         =>  $results[10],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'number',
#                                    'value'         =>  $results[11],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'prefetch_count',
#                                    'value'         =>  $results[12],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'transactional',
#                                    'value'         =>  $results[13],
#                                  );
#    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
#                                    'resource'      =>  'RabbitMQ|Channels',
#                                    'subresource'   =>  $results[1],
#                                    'name'          =>  'user',
#                                    'value'         =>  $results[14],
#                                  );
}
