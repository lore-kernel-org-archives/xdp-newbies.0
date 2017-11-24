Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from smtp2.iitd.ac.in ([103.27.10.44]:36406 "EHLO smtp2.iitd.ac.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753444AbdKXJT1 (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 24 Nov 2017 04:19:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp2.iitd.ac.in (Postfix) with ESMTP id BC17640025
        for <xdp-newbies@vger.kernel.org>; Fri, 24 Nov 2017 14:49:23 +0530 (IST)
Received: from smtp2.iitd.ac.in ([127.0.0.1])
        by localhost (smtp2.iitd.ac.in [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yywoeIMPeSTn for <xdp-newbies@vger.kernel.org>;
        Fri, 24 Nov 2017 14:49:20 +0530 (IST)
Received: from webmail.iitd.ac.in (webmail.iitd.ac.in [10.7.172.189])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: anmol07.visitor)
        by smtp2.iitd.ac.in (Postfix) with ESMTPSA id 7095841197
        for <xdp-newbies@vger.kernel.org>; Fri, 24 Nov 2017 14:47:16 +0530 (IST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Nov 2017 14:47:16 +0530
From: Anmol Panda <anmol07.visitor@cse.iitd.ac.in>
Subject: Adding entries to map
Reply-To: anmol07.visitor@cse.iitd.ac.in
Message-ID: <fffb0283bda7272e92a5e21e670d7a90@cse.iitd.ac.in>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>

Dear all,

    Hello. We are trying to create a map with multiple entries for 
destination mac addresses (order of millions). Firstly, we want to know 
if that can be done in XDP as BPF will not allow loops.

    Here is what we have tried so far.

       /* construct key */
       struct dstmactable_key key = {};
       key.field0 = hd.ethernet.destination;

       /* value */
       struct dstmactable_value new_value = { .action = Fallback_action, 
};
       /* add key / value pair to table*/
       bpf_map_update_elem(&dstmactable, &key, &new_value, BPF_ANY);

   We do this for every packet and expectedly, the lookup is a hit for 
every packet (each packet has the same dest address, although even with 
random addresses, the result is the same). We wish to add the entries 
statically before the program starts processing packets as an init() 
function. Where in the program should we write and call such a function?

Secondly, how can such a table be reset / deleted. If we run the 
following code (after commenting the addition of the new entries), we 
get a hit i.e. the HIT variable  = 1. On rebooting the machine, it 
prints HIT = 0. The code is as follows:


accept:
     {
         u8 hit;
         {
/* dstmactable.apply()*/
             {
  /* construct key */
//              struct dstmactable_key new_key = {};
//              new_key.field0 = 41014;
//
//              /* value */
//              struct dstmactable_value new_value = { .action = 
Fallback_action, };
//              /* add key / value pair to table*/
//              bpf_map_update_elem(&dstmactable, &new_key, &new_value, 
BPF_ANY);

                 /* construct key */
                 struct dstmactable_key key = {};
                 key.field0 = hd.ethernet.destination;
                 //key.field1 = hd.ethernet.etherType;
                 /* value */
                 struct dstmactable_value *value = NULL;
                 /* perform lookup */
                 value = bpf_map_lookup_elem(&dstmactable, &key);
                 if (value == NULL) {
                     /* miss; find default action */
                     hit = 0;
                     //printk("Hit = %d, value = NULL\n", hit);
                     value = 
bpf_map_lookup_elem(&dstmactable_defaultAction, &ebpf_zero);
                 } else {
                     hit = 1;
                     //printk("Hit = %d, value != NULL\n", hit);
                 }
                 if (value != NULL) {
                     /* run action */
                     switch (value->action) {
                         case Fallback_action:
                         {
                                 //printk("Hit = %d, Fallback action\n", 
hit);
                                 xout.output_action = XDP_TX;
                         }
                         break;
                         case Drop_action:
                         {
                                 //printk("Hit = %d, Drop action\n", 
hit);
                                 xout.output_action = XDP_DROP;
                         }
                         break;
                         default: return XDP_ABORTED;
                     }
                 }
                 else return XDP_ABORTED;
             }

Please guide us regarding the two queries we have in this regard. We 
eagerly await your response.

Thank you,
Sincerely,
