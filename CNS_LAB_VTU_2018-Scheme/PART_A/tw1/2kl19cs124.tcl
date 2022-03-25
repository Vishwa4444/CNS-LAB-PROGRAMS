#create a simulator object
set ns [new Simulator]

#open the NAM trace file
set nf [open tw1.nam w]
$ns namtrace-all $nf

#open the trace file
set nd [open tw1.tr w]
$ns trace-all $nd

#define a 'finish' procedure
proc finish {} {
	global ns nf nd
	$ns flush-trace
 	#Close the NAM trace file
	close $nf
	close $nd

	puts "running nam"

	#Execute nam on the trace file
	exec nam tw1.nam
	exit 0
}

#create three nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

#create links between the nodes
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 0.5Mb 10ms DropTail

#Set Queue Size of link (n1-n2) to 5
$ns queue-limit $n1 $n2 5

#Setup a UDP connection
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set sink [new Agent/Null]
$ns attach-agent $n2 $sink
$ns connect $udp0 $sink

#Setup a CBR over UDP connection (500 bytes every 5ms)
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Schedule events for the CBR agents
$ns at 0.2 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

#call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run














