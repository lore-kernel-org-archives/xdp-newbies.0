Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFFKpQ (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 6 Jun 2019 06:45:16 -0400
Date: Thu, 6 Jun 2019 13:44:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH][next] bpf: remove redundant assignment to err
Message-ID: <20190606104428.GK31203@kadam>
References: <20190603170247.9951-1-colin.king@canonical.com>
 <20190603102140.70fee157@cakuba.netronome.com>
 <276525bd-dd79-052e-7663-9acc92621853@canonical.com>
 <20190603104930.466a306b@cakuba.netronome.com>
 <e351d18c-21cd-6617-2a59-31a48be54b7e@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e351d18c-21cd-6617-2a59-31a48be54b7e@canonical.com>
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Colin Ian King <colin.king@canonical.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "David S . Miller" <davem@davemloft.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, netdev@vger.kernel.org, xdp-newbies@vger.kernel.org, bpf@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jun 03, 2019 at 07:07:20PM +0100, Colin Ian King wrote:
> On 03/06/2019 18:49, Jakub Kicinski wrote:
> > On Mon, 3 Jun 2019 18:39:16 +0100, Colin Ian King wrote:
> >> On 03/06/2019 18:21, Jakub Kicinski wrote:
> >>> On Mon,  3 Jun 2019 18:02:47 +0100, Colin King wrote:  
> >>>> From: Colin Ian King <colin.king@canonical.com>
> >>>>
> >>>> The variable err is assigned with the value -EINVAL that is never
> >>>> read and it is re-assigned a new value later on.  The assignment is
> >>>> redundant and can be removed.
> >>>>
> >>>> Addresses-Coverity: ("Unused value")
> >>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >>>> ---
> >>>>  kernel/bpf/devmap.c | 2 +-
> >>>>  kernel/bpf/xskmap.c | 2 +-
> >>>>  2 files changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> >>>> index 5ae7cce5ef16..a76cc6412fc4 100644
> >>>> --- a/kernel/bpf/devmap.c
> >>>> +++ b/kernel/bpf/devmap.c
> >>>> @@ -88,7 +88,7 @@ static u64 dev_map_bitmap_size(const union bpf_attr *attr)
> >>>>  static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
> >>>>  {
> >>>>  	struct bpf_dtab *dtab;
> >>>> -	int err = -EINVAL;
> >>>> +	int err;
> >>>>  	u64 cost;  
> >>>
> >>> Perhaps keep the variables ordered longest to shortest?  
> >>
> >> Is that a required coding standard?
> > 
> > For networking code, yes.  Just look around the files you're changing
> > and see for yourself.
> 
> Ah, informal coding standards. Great. Won't this end up with more diff
> churn?

Everyone knows that netdev uses reverse Christmas tree declarations...

regards,
dan carpenter
