Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56602 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdFAQLi (ORCPT
        <rfc822;xdp-newbies@vger.kernel.org>); Thu, 1 Jun 2017 12:11:38 -0400
Date: Thu, 01 Jun 2017 12:11:26 -0400 (EDT)
Message-Id: <20170601.121126.298708208451228255.davem@davemloft.net>
Subject: Re: Empty ethernet frame after XDP_TX
From: David Miller <davem@davemloft.net>
In-Reply-To: <7784F3C775469047B0E8C3B494DB28BEAF7DE1@EXC-MBX03.tsn.tno.nl>
References: <7784F3C775469047B0E8C3B494DB28BEAF7DE1@EXC-MBX03.tsn.tno.nl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: jeffrey.panneman@tno.nl
Cc: andy@greyhouse.net, xdp-newbies@vger.kernel.org


This is almost certainly a bug in generic XDP.
