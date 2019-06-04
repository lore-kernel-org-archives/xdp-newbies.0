Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:28418
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfFDSgA (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Tue, 4 Jun 2019 14:36:00 -0400
From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: Bad XDP performance with mlx5
Date: Tue, 4 Jun 2019 18:35:55 +0000
Message-ID: <822346c51bd76ec2ea5344bd669a9bfbe6bf7719.camel@mellanox.com>
References: <d7968b89-7218-1e76-86bf-c452b2f8d0c2@kth.se>
         <20190529191602.71eb6c87@carbon>
         <0836bd30-828a-9126-5d99-1d35b931e3ab@kth.se>
         <20190530094053.364b1147@carbon>
         <d695d08a-9ee1-0228-2cbb-4b2538a1d2f8@kth.se>
         <2218141a-7026-1cb8-c594-37e38eef7b15@kth.se>
         <20190531181817.34039c9f@carbon>
         <19ca7cd9a878b2ecc593cd2838b8ae0412463593.camel@mellanox.com>
         <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
In-Reply-To: <9f116335-0fad-079b-4070-89f24af4ab55@kth.se>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3D9AEA1EECD4944BABA5A37798A13CD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "barbette@kth.se" <barbette@kth.se>, Eran Ben Elisha <eranbe@mellanox.com>, Maxim Mikityanskiy <maximmi@mellanox.com>, "brouer@redhat.com" <brouer@redhat.com>
Cc: "toke@redhat.com" <toke@redhat.com>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>

T24gVHVlLCAyMDE5LTA2LTA0IGF0IDA5OjI4ICswMjAwLCBUb20gQmFyYmV0dGUgd3JvdGU6DQo+
IExlIDMxLzA1LzIwMTkgw6AgMjA6MDYsIFNhZWVkIE1haGFtZWVkIGEgw6ljcml0IDoNCj4gPiBU
aGUgcXVlc3Rpb24gaXMsIE9uIHRoZSBzYW1lIHBhY2tldCByYXRlL2JhbmR3aWR0aCBkbyB5b3Ug
c2VlDQo+ID4gaGlnaGVyDQo+ID4gY3B1IHV0aWxpemF0aW9uIG9uIG1seDUgY29tcGFyZWQgdG8g
b3RoZXIgZHJpdmVycz8geW91IGhhdmUgdG8NCj4gPiBjb21wYXJlDQo+ID4gYXBwbGVzIHRvIGFw
cGxlcy4NCj4gPiANCj4gSSBtZWFudCByZWxhdGl2ZSBpbmNyZWFzZS4gT2YgY291cnNlIGF0IDQw
RyB0aGUgWEw3MTAgaXMgdXNpbmcgbGVzcw0KPiBDUFUsIA0KPiBidXQgYWN0aXZhdGluZyBYRFAg
aXMgbmVhcmx5IGZyZWUuIEFzIFhEUCBpcyBwdXJlbHkgcGVyIHBhY2tldCBJDQo+IHdvdWxkIA0K
PiBleHBlY3QgdGhlIGNvc3Qgb2YgaXQgdG8gYmUgc2ltaWxhci4gRWcsIGEgZmV3IGluc3RydWN0
aW9ucyBwZXINCj4gcGFja2V0Lg0KPiANCj4gDQo+IFRoYW5rcyBKZXNwZXIgZm9yIGxvb2tpbmcg
aW50byB0aGlzIQ0KPiANCj4gSSBkb24ndCB0aGluayBJIHdpbGwgYmUgb2YgbXVjaCBoZWxwIGZ1
cnRoZXIgb24gdGhpcyBtYXR0ZXIuIE15IHRha2UNCj4gb3V0IA0KPiB3b3VsZCBiZTogYXMgYSBm
aXJzdC10aW1lIHVzZXIgbG9va2luZyBpbnRvIFhEUCBhZnRlciB3YXRjaGluZyBhDQo+IGRvemVu
IA0KPiBvZiBYRFAgdGFsa3MsIEkgd291bGQgaGF2ZSBleHBlY3RlZCBYRFAgZGVmYXVsdCBzZXR0
aW5ncyB0byBiZQ0KPiBpZGVudGljYWwgDQo+IHRvIFNLQiwgc28gSSBkb24ndCBoYXZlIHRvIHdh
dGNoIG91dCBmb3IgYSBzZXQgb2YgcGVyLWRyaXZlcg0KPiBwYXJhbWV0ZXIgDQo+IGNoZWNrbGlz
dCB0byBhdm9pZCBpbmNyZWFzaW5nIG15IENQVSBjb25zdW1wdGlvbiBieSAxNSUgd2hlbg0KPiBp
bnNlcnRpbmcgDQo+ICJhIHN1cGVyIGVmZmljaWVudCBhbmQgbGlnaHQgQlBGIHByb2dyYW0iLiBC
dXQgSSB1bmRlcnN0YW5kIGl0J3Mgbm90IA0KPiB0aGF0IGVhc3kuLi4NCj4gDQoNCkhpIFRvbSwN
Cg0KRG9uJ3QgZ2l2ZSB1cCBzbyBlYXN5IG9uIFhEUCA6KQ0KbGV0IG1lIGRvIGEgcXVpY2sgdGVz
dCBhbmQgc2VlIGhvdyB3ZSBjYW4gaGVscCBoZXJlLiANCg0KPiBUb20NCg==
