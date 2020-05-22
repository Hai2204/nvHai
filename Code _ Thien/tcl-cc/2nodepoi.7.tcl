StatCollector set debug_ 0
Classifier/BaseClassifier/EdgeClassifier set type_ 0
Classifier/BaseClassifier/CoreClassifier set type_ 1
source /home/IEUser/ns-allinone-2.28/ns-2.28/obs-0.9a/tcl/lib/ns-obs-lib.tcl
source /home/IEUser/ns-allinone-2.28/ns-2.28/obs-0.9a/tcl/lib/ns-optic-link.tcl
source /home/IEUser/ns-allinone-2.28/ns-2.28/obs-0.9a/tcl/lib/ns-obs-defaults.tcl
set ns [new Simulator]
set nf [open nodepoi20.nam w]
set sc [new StatCollector]
set tf [open two_node.tr w]
set ndf [open two_nodeloi.tr w]
#set tf [open "| grep \"d\" > min1.tr" w]
#$ns namtrace-all $nf
#$ns trace-all $tf
#$ns nodetrace-all $ndf
BurstManager maxburstsize 10000
BurstManager bursttimeout 0.0001
Classifier/BaseClassifier/CoreClassifier set bhpProcTime 0.0000015
Classifier/BaseClassifier/EdgeClassifier set bhpProcTime 0.000001
#option 0  
#option 1   Su dung FDL tai nut loi
Classifier/BaseClassifier set option 0  
#ebufoption 1 su dung bo dem tai nui bien
Classifier/BaseClassifier set ebufoption 1
OBSFiberDelayLink set FDLdelay 0.00001
puts "DUMBBELL"

#Thiet lap so nut bien la 18, so nut loi la 2
set edge_count 18
set core_count 2
puts "So luong nut bien: $edge_count"
puts "So luong nut loi: $core_count"


#bwpc 1000000000  10Gb bang thong 
set bwpc 1000000000
set delay 1ms
puts "Bang thong: $bwpc"
puts "Do tre: $delay"

#set maxch    so kenh tren moi day quang
set maxch 6

#set ncc    So kenh nut dieu kien BCH
set ncc 2

#set ndc   So kenh du lieu
set ndc 4

puts "So kenh: $maxch"
puts "So kenh nut dieu khien: $ncc"
puts "So kenh du lieu: $ndc"

proc finish {} {
    global ns nf sc tf ndf
    $ns flush-trace
    $ns flush-nodetrace
    close $nf
    close $tf
    close $ndf
    $sc display-sim-list
     puts "Simulation complete";
    exit 0
}

#tao topo
Simulator instproc  create_topology { } {
    $self instvar Node_
    global E C 
    global edge_count core_count
    global bwpc maxch ncc ndc delay
	set i 0
    while { $i < $edge_count } {
	set E($i) [$self create-edge-node $edge_count]
        set nid [$E($i) id]
        set string1 "E($i) node id:     $nid"
        puts $string1
	incr i
    }
    set i 0
    while { $i < $core_count } {
	set C($i) [$self create-core-node $core_count]
        set nid [$C($i) id]
        set string1 "C($i) node id:     $nid"
        puts $string1
	incr i
    }
    $self createDuplexFiberLink $E(0) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(1) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(2) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(3) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(4) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(5) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(6) $C(0) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(7) $C(0) $bwpc $delay $ncc $ndc $maxch
	$self createDuplexFiberLink $E(8) $C(0) $bwpc $delay $ncc $ndc $maxch
    
	$self createDuplexFiberLink $E(9) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(10) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(11) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(12) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(13) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(14) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(15) $C(1) $bwpc $delay $ncc $ndc $maxch
    $self createDuplexFiberLink $E(16) $C(1) $bwpc $delay $ncc $ndc $maxch
	$self createDuplexFiberLink $E(17) $C(1) $bwpc $delay $ncc $ndc $maxch	
   	$self createDuplexFiberLink $C(0) $C(1) $bwpc $delay $ncc $ndc $maxch
	$self build-routing-table
} 

#Khai bao luong vao
Simulator instproc  create_pois_connection1 {src dest start0 stop0 rate} {
     upvar 1 $src srcr
     upvar 1 $dest destr
	set Pois_UDP_agent [new Agent/UDP]
	set Pois_UDP_sink [new Agent/Null]
	$Pois_UDP_agent set fid_ 1
    $Pois_UDP_agent set prio_ 1
	$self attach-agent $srcr $Pois_UDP_agent
	$self attach-agent $destr $Pois_UDP_sink
	$self connect $Pois_UDP_agent $Pois_UDP_sink
	set POI [new Application/Traffic/Poisson]
	$POI attach-agent $Pois_UDP_agent
	$POI set rate_ $rate
	set startTime $start0
	set stopTime $stop0
    $self at $startTime  "$POI start"
    $self at $stopTime "$POI stop"
	
     puts "poison traffic stream between $src = $srcr and $dest = $destr created"
}
Simulator instproc  create_pois_connection0 {src dest start0 stop0 rate1} {
     upvar 1 $src srcr
     upvar 1 $dest destr
	set Pois_UDP_agent [new Agent/UDP]
	set Pois_UDP_sink [new Agent/Null]
	$self attach-agent $srcr $Pois_UDP_agent
	$self attach-agent $destr $Pois_UDP_sink
	$self connect $Pois_UDP_agent $Pois_UDP_sink
	set POI [new Application/Traffic/Poisson]
	$POI attach-agent $Pois_UDP_agent
	$POI set rate_ $rate1
	set startTime $start0
	set stopTime $stop0
    $self at $startTime  "$POI start"
    $self at $stopTime "$POI stop"
	
     puts "poison traffic stream between $src = $srcr and $dest = $destr created"
}
Simulator instproc  create_pois_connection2 {src dest start0 stop0 rate2} {
     upvar 1 $src srcr
     upvar 1 $dest destr
	set Pois_UDP_agent [new Agent/UDP]
	set Pois_UDP_sink [new Agent/Null]
	$Pois_UDP_agent set fid_ 2
    $Pois_UDP_agent set prio_ 2
	$self attach-agent $srcr $Pois_UDP_agent
	$self attach-agent $destr $Pois_UDP_sink
	$self connect $Pois_UDP_agent $Pois_UDP_sink
	set POI [new Application/Traffic/Poisson]
	$POI attach-agent $Pois_UDP_agent
	$POI set rate_ $rate2
	set startTime $start0
	set stopTime $stop0
    $self at $startTime  "$POI start"
    $self at $stopTime "$POI stop"
	
     puts "poison traffic stream between $src = $srcr and $dest = $destr created"
}

Simulator instproc  create_pois_connection3 {src dest start0 stop0 rate3} {
     upvar 1 $src srcr
     upvar 1 $dest destr
	set Pois_UDP_agent [new Agent/UDP]
	set Pois_UDP_sink [new Agent/Null]
	$Pois_UDP_agent set fid_ 3
    $Pois_UDP_agent set prio_ 3
	$self attach-agent $srcr $Pois_UDP_agent
	$self attach-agent $destr $Pois_UDP_sink
	$self connect $Pois_UDP_agent $Pois_UDP_sink
	set POI [new Application/Traffic/Poisson]
	$POI attach-agent $Pois_UDP_agent
	$POI set rate_ $rate3
	set startTime $start0
	set stopTime $stop0
    $self at $startTime  "$POI start"
    $self at $stopTime "$POI stop"
	
     puts "poison traffic stream between $src = $srcr and $dest = $destr created"
}
Simulator instproc  create_pois_connection4 {src dest start0 stop0 rate4} {
     upvar 1 $src srcr
     upvar 1 $dest destr
	set Pois_UDP_agent [new Agent/UDP]
	set Pois_UDP_sink [new Agent/Null]
	$Pois_UDP_agent set fid_ 4
    $Pois_UDP_agent set prio_ 4
	$self attach-agent $srcr $Pois_UDP_agent
	$self attach-agent $destr $Pois_UDP_sink
	$self connect $Pois_UDP_agent $Pois_UDP_sink
	set POI [new Application/Traffic/Poisson]
	$POI attach-agent $Pois_UDP_agent
	$POI set rate_ $rate4
	set startTime $start0
	set stopTime $stop0
    $self at $startTime  "$POI start"
    $self at $stopTime "$POI stop"
	
     puts "poison traffic stream between $src = $srcr and $dest = $destr created"
}
set stime 0.0
set etime 4.0

#Thiet lap Tai   
set rate 49218750   	 
set rate1 49218750   	 
set rate2 65625000   	 
set rate3 65625000   	 
set rate4 98437500   


puts "Thiet lap thong so tai"
puts "Tai 0: $rate"
puts "Tai 1: $rate1"
puts "Tai 2: $rate2"
puts "Tai 3: $rate3"
puts "Tai 4: $rate4"

$ns create_topology
Application/Traffic/Poisson set packetSize_ 2000
Application/Traffic/Poisson set maxpkts_ 268435456

$ns  create_pois_connection0 E(0) E(9) $stime $etime $rate
$ns  create_pois_connection1 E(1) E(10) $stime $etime $rate
$ns  create_pois_connection2 E(2) E(11) $stime $etime $rate1
$ns  create_pois_connection3 E(3) E(12) $stime $etime $rate1
$ns  create_pois_connection4 E(4) E(13) $stime $etime $rate2
$ns  create_pois_connection0 E(5) E(14) $stime $etime $rate2
$ns  create_pois_connection1 E(6) E(15) $stime $etime $rate3
$ns  create_pois_connection2 E(7) E(16) $stime $etime $rate3
$ns  create_pois_connection3 E(8) E(17) $stime $etime $rate4

$ns  create_pois_connection0 E(0) E(9) $stime $etime $rate
$ns  create_pois_connection1 E(1) E(10) $stime $etime $rate
$ns  create_pois_connection2 E(2) E(11) $stime $etime $rate1
$ns  create_pois_connection3 E(3) E(12) $stime $etime $rate1
$ns  create_pois_connection4 E(4) E(13) $stime $etime $rate2
$ns  create_pois_connection0 E(5) E(14) $stime $etime $rate2
$ns  create_pois_connection1 E(6) E(15) $stime $etime $rate3
$ns  create_pois_connection2 E(7) E(16) $stime $etime $rate3
$ns  create_pois_connection3 E(8) E(17) $stime $etime $rate4

$ns  create_pois_connection0 E(0) E(9) $stime $etime $rate
$ns  create_pois_connection1 E(1) E(10) $stime $etime $rate
$ns  create_pois_connection2 E(2) E(11) $stime $etime $rate1
$ns  create_pois_connection3 E(3) E(12) $stime $etime $rate1
$ns  create_pois_connection4 E(4) E(13) $stime $etime $rate2
$ns  create_pois_connection0 E(5) E(14) $stime $etime $rate2
$ns  create_pois_connection1 E(6) E(15) $stime $etime $rate3
$ns  create_pois_connection2 E(7) E(16) $stime $etime $rate3
$ns  create_pois_connection3 E(8) E(17) $stime $etime $rate4

$ns  create_pois_connection0 E(0) E(9) $stime $etime $rate
$ns  create_pois_connection1 E(1) E(10) $stime $etime $rate
$ns  create_pois_connection2 E(2) E(11) $stime $etime $rate1
$ns  create_pois_connection3 E(3) E(12) $stime $etime $rate1
$ns  create_pois_connection4 E(4) E(13) $stime $etime $rate2
$ns  create_pois_connection0 E(5) E(14) $stime $etime $rate2
$ns  create_pois_connection1 E(6) E(15) $stime $etime $rate3
$ns  create_pois_connection2 E(7) E(16) $stime $etime $rate3
$ns  create_pois_connection3 E(8) E(17) $stime $etime $rate4

$ns  create_pois_connection0 E(0) E(9) $stime $etime $rate
$ns  create_pois_connection1 E(1) E(10) $stime $etime $rate
$ns  create_pois_connection2 E(2) E(11) $stime $etime $rate1
$ns  create_pois_connection3 E(3) E(12) $stime $etime $rate1
$ns  create_pois_connection4 E(4) E(13) $stime $etime $rate2
$ns  create_pois_connection0 E(5) E(14) $stime $etime $rate2
$ns  create_pois_connection1 E(6) E(15) $stime $etime $rate3
$ns  create_pois_connection2 E(7) E(16) $stime $etime $rate3
$ns  create_pois_connection3 E(8) E(17) $stime $etime $rate4

$ns  create_pois_connection0 E(0) E(9) $stime $etime $rate
$ns  create_pois_connection1 E(1) E(10) $stime $etime $rate
$ns  create_pois_connection2 E(2) E(11) $stime $etime $rate1
$ns  create_pois_connection3 E(3) E(12) $stime $etime $rate1
$ns  create_pois_connection4 E(4) E(13) $stime $etime $rate2
$ns  create_pois_connection0 E(5) E(14) $stime $etime $rate2
$ns  create_pois_connection1 E(6) E(15) $stime $etime $rate3
$ns  create_pois_connection2 E(7) E(16) $stime $etime $rate3
$ns  create_pois_connection3 E(8) E(17) $stime $etime $rate4



$ns at 9.0 "finish"
$ns run
