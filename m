Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-qk1-f174.google.com ([209.85.222.174]:43195 "EHLO
        mail-qk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbfFHC4N (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Fri, 7 Jun 2019 22:56:13 -0400
Received: by mail-qk1-f174.google.com with SMTP id m14so2491234qka.10
        for <xdp-newbies@vger.kernel.org>; Fri, 07 Jun 2019 19:56:13 -0700 (PDT)
MIME-Version: 1.0
From: William Tu <u9012063@gmail.com>
Date: Fri, 7 Jun 2019 19:55:34 -0700
Message-ID: <CALDO+SZ_y2crYSXGtFxQtk8zZz2X=Fr-rJTPr_zm6rbtD8h9iQ@mail.gmail.com>
Subject: AF_XDP with QoS support question
Content-Type: text/plain; charset="UTF-8"
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: Xdp <xdp-newbies@vger.kernel.org>, "<dev@openvswitch.org>" <dev@openvswitch.org>

Hi,

When using AF_XDP, the TC qdisc layer is by-passed and packets go to
userspace directly. One problem is that there is no QoS support when
using AF_XDP.

For egress shaping, I'm thinking about using tc-mqprio, which has
hardware offload support. And for OVS, we can add tc-mqprio support.
For ingress policing, I don't know how to do it. Is there an hardware
offload ingress policing support?

Thanks
William
