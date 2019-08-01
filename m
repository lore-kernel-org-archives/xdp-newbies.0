Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731616AbfHASAa (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 1 Aug 2019 14:00:30 -0400
Subject: [net v1 PATCH 3/4] selftests/bpf: reduce time to execute
 test_xdp_vlan.sh
From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Thu, 01 Aug 2019 20:00:26 +0200
Message-ID: <156468242676.27559.5206877790597119575.stgit@firesoul>
In-Reply-To: <156468229108.27559.2443904494495785131.stgit@firesoul>
References: <156468229108.27559.2443904494495785131.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: xdp-newbies@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>, brandon.cazander@multapplied.net, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Jesper Dangaard Brouer <brouer@redhat.com>

Given the increasing number of BPF selftests, it makes sense to
reduce the time to execute these tests.  The ping parameters are
adjusted to reduce the time from measures 9 sec to approx 2.8 sec.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/test_xdp_vlan.sh |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xdp_vlan.sh b/tools/testing/selftests/bpf/test_xdp_vlan.sh
index 7348661be815..bb8b0da91686 100755
--- a/tools/testing/selftests/bpf/test_xdp_vlan.sh
+++ b/tools/testing/selftests/bpf/test_xdp_vlan.sh
@@ -188,7 +188,7 @@ ip netns exec ns2 ip link set lo up
 # At this point, the hosts cannot reach each-other,
 # because ns2 are using VLAN tags on the packets.
 
-ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Okay ping fails"'
+ip netns exec ns2 sh -c 'ping -W 1 -c 1 100.64.41.1 || echo "Success: First ping must fail"'
 
 
 # Now we can use the test_xdp_vlan.c program to pop/push these VLAN tags
@@ -210,8 +210,8 @@ ip netns exec ns1 tc filter add dev $DEVNS1 egress \
   prio 1 handle 1 bpf da obj $FILE sec tc_vlan_push
 
 # Now the namespaces can reach each-other, test with ping:
-ip netns exec ns2 ping -W 2 -c 3 $IPADDR1
-ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
+ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
 
 # Second test: Replace xdp prog, that fully remove vlan header
 #
@@ -224,5 +224,5 @@ ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE off
 ip netns exec ns1 ip link set $DEVNS1 $XDP_MODE object $FILE section $XDP_PROG
 
 # Now the namespaces should still be able reach each-other, test with ping:
-ip netns exec ns2 ping -W 2 -c 3 $IPADDR1
-ip netns exec ns1 ping -W 2 -c 3 $IPADDR2
+ip netns exec ns2 ping -i 0.2 -W 2 -c 2 $IPADDR1
+ip netns exec ns1 ping -i 0.2 -W 2 -c 2 $IPADDR2
