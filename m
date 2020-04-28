Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:37684 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728191AbgD1RMI (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 28 Apr 2020 13:12:08 -0400
Received: from pps.filterd (m0048493.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SHBWtd018094
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 10:12:08 -0700
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
        by mx0a-00169c01.pphosted.com with ESMTP id 30mm8q305p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 10:12:08 -0700
Received: by mail-vk1-f197.google.com with SMTP id j206so5230589vke.11
        for <xdp-newbies@vger.kernel.org>; Tue, 28 Apr 2020 10:12:06 -0700 (PDT)
MIME-Version: 1.0
From: John McDowall <jmcdowall@paloaltonetworks.com>
Date: Tue, 28 Apr 2020 10:11:53 -0700
Message-ID: <CAHQoOTZGdLYZ=qjF8+Rwi+E5y_st1u1CwMPiP65UHWpvRXvhZA@mail.gmail.com>
Subject: XDP Native mode with public cloud (GCP)
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To: "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>

Hi,

I am running the XDP redirect example on Google Cloud Platform using
the GCP provided Ubuntu 20.04 image as my host. The code works fine in
SKB_MODE (xdpgeneric). When I go to DRV_MODE I get the following error
message:   "libbpf: Kernel error message: virtio_net: XDP expects
header/data in single page, any_header_sg required".

For all images on GCP that I have looked at the number of RX and TX
channels are set to 0 and the combined is the number of cores (ethtool
-l dev). My question is then, is there any way to run XDP native on
GCP images or do I need to try and create a custom image with re and
tx queues set?

Second question, does anyone have experience running native XDP on AWS
and Azure?

Regards

John
