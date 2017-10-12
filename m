Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdJLLET (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Thu, 12 Oct 2017 07:04:19 -0400
Date: Thu, 12 Oct 2017 13:04:12 +0200
From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH, bpf-llvm] Fix bug on silently truncating 64-bit
 immediate
Message-ID: <20171012130412.72432f87@redhat.com>
In-Reply-To: <1507803690-17709-1-git-send-email-jiong.wang@netronome.com>
References: <1507803690-17709-1-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Jiong Wang <jiong.wang@netronome.com>
Cc: xdp-newbies@vger.kernel.org, yhs@fb.com, iovisor-dev@lists.iovisor.org, oss-drivers@netronome.com, brouer@redhat.com, hans@hanshq.net

On Thu, 12 Oct 2017 06:21:30 -0400
Jiong Wang <jiong.wang@netronome.com> wrote:

> We came across an llvm bug when compiling some testcases that 64-bit
> immediates are silently truncated into 32-bit and then packed into
> BPF_JMP | BPF_K encoding.  This caused comparison with wrong value.

I think you send this to the wrong mailing list... this looks like a
patch against the LLVM source code.

Shouldn't you send to: llvm-dev@lists.llvm.org ?
 
> This bug looks to be introduced by r308080.  

This looks like a very recent change:
  https://llvm.org/viewvc/llvm-project?view=revision&revision=308080
  Sat Jul 15 05:41:42 2017 UTC (2 months, 4 weeks ago)

(As you are sending this to a user mailing list: xdp-newbies@vger.kernel.org)

I want to know if this have made it into a LLVM release? and which release?

As the git-repo[1] replica of LLVM SVN-repo does not git-tag the
releases, I could not answer this question myself via the command:

$ git describe --contains 7c423e0690

[1] http://llvm.org/git/llvm.git

> The Select_Ri pattern is
> supposed to be lowered into J*_Ri while the latter only support 32-bit
> immediate encoding, therefore Select_Ri should have similar immediate
> predicate check as what J*_Ri are doing.
> 
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> ---
>  lib/Target/BPF/BPFISelLowering.cpp |  8 ++++++--
>  lib/Target/BPF/BPFInstrInfo.td     |  2 +-
>  test/CodeGen/BPF/select_ri.ll      | 35 +++++++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 3 deletions(-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
