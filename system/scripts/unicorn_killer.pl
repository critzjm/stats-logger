#!/usr/bin/perl

$instance_type = `curl -s http://169.254.169.254/latest/meta-data/instance-type`;
$max_memory = 14.0;
$max_memory = 4.2 if ( $instance_type eq 'c1.xlarge' );
open(PS_FH, "ps -eo pid,pmem,cmd | grep unicorn | grep worker | grep -v grep |");
while ( <PS_FH> )
{
  chomp;
  ($pid, $mem, undef) = split;

  if ($mem >= 50.0)
  {
    system("kill -9 $pid");
  }
  elsif ($mem >= $max_memory)
  {
    system("kill -QUIT $pid");
  }
  else
  {
    # do nothing
  }
}
close(PS_FH);
