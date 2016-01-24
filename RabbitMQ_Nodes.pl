#!/bin/perl

=head1 NAME

 RabbitMQ_Nodes.pl

=head1 SYNOPSIS

 IntroscopeEPAgent.properties configuration

 introscope.epagent.plugins.stateless.names=NODES
 introscope.epagent.stateless.NODES.command=perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Nodes.pl --host host_or_ip_addr --port 12345 --user username --pswd password
 introscope.epagent.stateless.NODES.delayInSeconds=15

=head1 DESCRIPTION

 Pulls statistics about bindings

 To see help information:

 perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Nodes.pl --help

 or run with no commandline arguments.

 To test against sample output, use the DEBUG flag:

 perl <epa_home>/epaplugins/rabbitmq/RabbitMQ_Nodes.pl --debug

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
use POSIX qw(strftime);
use File::Slurp qw(read_file);


=head2 SUBROUTINES

=cut

=head3 UPTIME

 Prints days, mins, secs based upon uptime secs

=cut

sub uptime{
    my $uptime = int(shift);
    my $days = ($uptime / (60 * 60) %24);
    my $mins = ($uptime / 60 %60);
    my $secs = ($uptime %60);

    return "$days days, $mins mins, $secs secs";
}

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
    #@arrayResults = do { open my $fh, '<', File::Spec->catfile(abs_path, "epaplugins", "RabbitMQ", "samples", "nodes.txt"); <$fh>; }
    # if you do not have File::Slurp installed, remove the "use" reference, comment out the next line, and uncommment the previous line
    @arrayResults = read_file(File::Spec->catfile("samples", "nodes.txt"));
} else {
    # determine path to rabbitmqadmin.py; adjust path as needed for your environment
    $rabbitmqadmin = File::Spec->catfile(abs_path, "epaplugins", "RabbitMQ", "rabbitmqadmin.py");
    # command to execute rabbitmqadmin.py
    $execCommand="python $rabbitmqadmin --host=$rmqHost --port=$rmqPort --username=$rmqUser --password=$rmqPswd --format=tsv list nodes";
    # execute command, place results into array
    @arrayResults=`$execCommand`;
}


# skip first row; iterate through results
for my $i ( 1..$#arrayResults ) {
    # remove trailing newline
    chomp $arrayResults[$i];
    # split on tab "\t"
    my @results = split('\t', $arrayResults[$i]);
    # check @results for empty string & replace with "Unknown"
    foreach ( @results ) {
        if ( length($_) == 0 ) { $_ = "Unknown"; }
    }
    # return results; use "name" column as subresource
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'type',
                                    'value'         =>  $results[1],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'application',
                                    'value'         =>  $results[2],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'auth_mechanisms',
                                    'value'         =>  $results[3],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'contexts',
                                    'value'         =>  $results[4],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'disk_free',
                                    'value'         =>  $results[5],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'disk_free_alarm',
                                    'value'         =>  $results[6],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'disk_free_limit',
                                    'value'         =>  $results[7],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'exchange_types',
                                    'value'         =>  $results[8],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'fd_used',
                                    'value'         =>  $results[10],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'mem_alarm',
                                    'value'         =>  $results[11],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'mem_limit',
                                    'value'         =>  $results[12],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'mem_used',
                                    'value'         =>  $results[13],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'os_pid',
                                    'value'         =>  $results[14],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'partitions',
                                    'value'         =>  $results[15],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'proc_total',
                                    'value'         =>  $results[16],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'proc_used',
                                    'value'         =>  $results[17],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'processors',
                                    'value'         =>  $results[18],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'run_queue',
                                    'value'         =>  $results[19],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'running',
                                    'value'         =>  $results[20],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'sockets_total',
                                    'value'         =>  $results[21],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'LongCounter',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'sockets_used',
                                    'value'         =>  $results[22],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'statistics_level',
                                    'value'         =>  $results[23],
                                  );
    Wily::PrintMetric::printMetric( 'type'          =>  'StringEvent',
                                    'resource'      =>  'RabbitMQ|Nodes',
                                    'subresource'   =>  $results[0],
                                    'name'          =>  'uptime',
                                    'value'         =>  &uptime($results[24]),
                                  );
}
