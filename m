Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbeDMRN4 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 13 Apr 2018 13:13:56 -0400
Subject: Re: XDP performance regression due to CONFIG_RETPOLINE Spectre V2
References: <20180412155029.0324fe58@redhat.com>
 <20180412145123.GA7048@lst.de> <20180412145653.GA7172@lst.de>
From: Tushar Dave <tushar.n.dave@oracle.com>
Message-ID: <fbcb4cc8-53fb-82cd-bd9d-76c5fdd47918@oracle.com>
Date: Fri, 13 Apr 2018 10:12:41 -0700
MIME-Version: 1.0
In-Reply-To: <20180412145653.GA7172@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>, Jesper Dangaard Brouer <brouer@redhat.com>
Cc: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, William Tu <u9012063@gmail.com>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>, "Karlsson, Magnus" <magnus.karlsson@intel.com>, Alexander Duyck <alexander.duyck@gmail.com>, Arnaldo Carvalho de Melo <acme@redhat.com>



On 04/12/2018 07:56 AM, Christoph Hellwig wrote:
> On Thu, Apr 12, 2018 at 04:51:23PM +0200, Christoph Hellwig wrote:
>> On Thu, Apr 12, 2018 at 03:50:29PM +0200, Jesper Dangaard Brouer wrote:
>>> ---------------
>>> Implement support for keeping the DMA mapping through the XDP return
>>> call, to remove RX map/unmap calls.  Implement bulking for XDP
>>> ndo_xdp_xmit and XDP return frame API.  Bulking allows to perform DMA
>>> bulking via scatter-gatter DMA calls, XDP TX need it for DMA
>>> map+unmap. The driver RX DMA-sync (to CPU) per packet calls are harder
>>> to mitigate (via bulk technique). Ask DMA maintainer for a common
>>> case direct call for swiotlb DMA sync call ;-)
>>
>> Why do you even end up in swiotlb code?  Once you bounce buffer your
>> performance is toast anyway..
> 
> I guess that is because x86 selects it as the default as soon as
> we have more than 4G memory. That should be solveable fairly easily
> with the per-device dma ops, though.\

I guess there is nothing we need to do!

On x86, in case of no intel iommu or iommu is disabled, you end up in
swiotlb for DMA API calls when system has 4G memory.
However, AFAICT, for 64bit DMA capable devices swiotlb DMA APIs do not
use bounce buffer until and unless you have swiotlb=force specified in
kernel commandline.

e.g. here is the snip:
dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
                             unsigned long offset, size_t size,
                             enum dma_data_direction dir,
                             unsigned long attrs)
{
         phys_addr_t map, phys = page_to_phys(page) + offset;
         dma_addr_t dev_addr = phys_to_dma(dev, phys);

         BUG_ON(dir == DMA_NONE);
         /*
          * If the address happens to be in the device's DMA window,
          * we can safely return the device addr and not worry about bounce
          * buffering it.
          */
         if (dma_capable(dev, dev_addr, size) && swiotlb_force != 
SWIOTLB_FORCE)
                 return dev_addr;


-Tushar
