Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35202 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752471AbeD0Nz2 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 27 Apr 2018 09:55:28 -0400
Subject: Re: egress packet filtering
References: <CAArOQ2UJDD-kA3O9h-MZTedhyRfXg4UC=QM-Hdw9tzPoe__ZvQ@mail.gmail.com>
 <fd4bc543-a590-ab95-145e-0b3a76e6b892@solarflare.com>
 <CAArOQ2X+VfNCejk8HwqfZ38Ed253EShshvXkL-=Ay_bd9ahPuQ@mail.gmail.com>
From: Edward Cree <ecree@solarflare.com>
Message-ID: <a0a2300a-44cb-6056-ef41-6bde47aa893e@solarflare.com>
Date: Fri, 27 Apr 2018 14:55:22 +0100
MIME-Version: 1.0
In-Reply-To: <CAArOQ2X+VfNCejk8HwqfZ38Ed253EShshvXkL-=Ay_bd9ahPuQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Bobby Powers <bobbypowers@gmail.com>
Cc: xdp-newbies@vger.kernel.org

On 27/04/18 14:41, Bobby Powers wrote:
> Does that mean it is possible (if slow) to use an XDP filter for TX?
No, there is no current support for running XDP on TX.  My previous
 email was an attempt to explain why.

-Ed
