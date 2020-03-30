Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-pj1-f54.google.com ([209.85.216.54]:37160 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbgC3QY3 (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Mon, 30 Mar 2020 12:24:29 -0400
Received: by mail-pj1-f54.google.com with SMTP id o12so7555729pjs.2
        for <xdp-newbies@vger.kernel.org>; Mon, 30 Mar 2020 09:24:28 -0700 (PDT)
Subject: Re: Using AF_XDP To Modify Outgoing Packets
References: <7902d2f1-1c21-f3e8-5035-352bba130d50@gflclan.com>
From: David Ahern <dsahern@gmail.com>
Message-ID: <1bcd8d55-1d31-e46f-a2e9-15b03c0c74ac@gmail.com>
Date: Mon, 30 Mar 2020 10:24:26 -0600
MIME-Version: 1.0
In-Reply-To: <7902d2f1-1c21-f3e8-5035-352bba130d50@gflclan.com>
Content-Language: en-US
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Christian Deacon <gamemann@gflclan.com>, xdp-newbies@vger.kernel.org

On 3/30/20 10:11 AM, Christian Deacon wrote:
> If this isn't possible, are there any plans to add TX path support into
> XDP in the future?

I am working on it. Latest set is here:
   https://github.com/dsahern/linux/commits/xdp/egress-rfc5-06

does not include support for AF_XDP, but hopefully that can be added
later by someone with more knowledge of socket needs.
