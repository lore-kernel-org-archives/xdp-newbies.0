Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725892AbfK2LMn (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 29 Nov 2019 06:12:43 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8B0B56BDD
        for <xdp-newbies@vger.kernel.org>; Fri, 29 Nov 2019 11:12:39 +0000 (UTC)
Date: Fri, 29 Nov 2019 12:12:32 +0100
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Video for understanding eBPF conceptually
Message-ID: <20191129121232.5e5a31ec@carbon>
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>
Cc: brouer@redhat.com


Brendan Gregg (NetFlix) claim that eBPF is the first fundamental change
to how kernels are used in 50 years, and explain why in this 31 minutes
video.

 https://www.youtube.com/watch?v=7pmXdG8-7WU

I really recommend to watch this video, to understand why the BPF model
is so fundamentally different from the existing OS model we all assume.

XDP is mentioned, but XDP is just a user of BPF, that takes advantage
of the BPF model.  As I've said before, the real power comes when
combining several BPF hooks.  Go explore the BCC/bpftrace tracing tools
that are also mentioned.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
