#!/usr/bin/perl
#
# A daemon to monitor a process by name and kill it when it surpasses a given
# uptime
#
# Author: Bremen Braun

use strict;
use Proc::ProcessTable;
use Daemon::Daemonize qw(:all);
use Getopt::Long;

# Process options
my $uid = undef;
my $signal = 9;
my $sleep = 1;
GetOptions(
	"uid=i"   => \$uid, # only kill processes for a certain user (default: kill for all users, if permissions allow)
	"sleep=i" => \$sleep # time to sleep between daemon cycles (default: 1 second)
) or die $!;

die("Wrong number of arguments\n" . print_usage($0)) unless scalar(@ARGV) == 2;
my ($proc, $timeout) = @ARGV;

my $pt = Proc::ProcessTable->new();
daemonize(run => sub {
	while (1) {
		my @procs = @{$pt->table()};
	
		if (defined $uid) {
			@procs = filter_procs_to_uid($uid, @procs);
		}
		kill -9, map {$_->pid} filter_procs_to_uptime($timeout, filter_procs_to_process($proc, @procs));
		sleep $sleep;
	}
});

# Return all processes which have run for longer than $time seconds
sub filter_procs_to_uptime {
	my ($time, @procs) = @_;
	
	my $min = time - $time; # the minimum start time to not be picked up by this filter
	my @filtered;
	foreach my $p (@procs) {
		push(@filtered, $p) if $p->start < $min;
	}
	return @filtered;
}

# Return all processes which were started with user having uid $uid
sub filter_procs_to_uid {
	my ($uid, @procs) = @_;
	
	my @filtered;
	foreach my $p (@procs) {
		push(@filtered, $p) if $p->uid == $uid;
	}
	return @filtered;
}

# Return all processes matching process name $pname
sub filter_procs_to_process {
	my ($pname, @procs) = @_;
	
	my @filtered;
	foreach my $p (@procs) {
		push(@filtered, $p) if $p->fname eq $pname;
	}
	return @filtered;
}

sub print_usage {
	my $pname = shift;
	
	return <<EOS;
Usage: $pname [OPTIONS] process_name timeout

Monitor a process with name `process_name`, killing it when it has run longer
than `timeout` (in seconds)
OPTIONS:
  --uid <INT>       Only kill processes named `process_name` if started by a
                    given user
  --sleep <INT>     Time to sleep (in seconds) between daemon loops
EOS
}
