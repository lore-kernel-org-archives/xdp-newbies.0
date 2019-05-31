Return-Path: <xdp-newbies-owner@vger.kernel.org>
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:18629
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfEaWII (ORCPT <rfc822;xdp-newbies@vger.kernel.org>);
        Fri, 31 May 2019 18:08:08 -0400
From: Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Date: Fri, 31 May 2019 22:08:03 +0000
Message-ID: <a65de3a257ab5ebec83e817c092f074b58b9ae47.camel@mellanox.com>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
         <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
         <20190531174643.4be8b27f@carbon> <20190531162523.GA3694@khorivan>
         <20190531183241.255293bc@carbon> <20190531170332.GB3694@khorivan>
In-Reply-To: <20190531170332.GB3694@khorivan>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-ID: <53B36BEEBA016349819171CA9F2B689F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: xdp-newbies-owner@vger.kernel.org
List-ID: <xdp-newbies.vger.kernel.org>
To: "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>, "brouer@redhat.com" <brouer@redhat.com>
Cc: "daniel@iogearbox.net" <daniel@iogearbox.net>, "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>, "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>, "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>, "hawk@kernel.org" <hawk@kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>

T24gRnJpLCAyMDE5LTA1LTMxIGF0IDIwOjAzICswMzAwLCBJdmFuIEtob3JvbnpodWsgd3JvdGU6
DQo+IE9uIEZyaSwgTWF5IDMxLCAyMDE5IGF0IDA2OjMyOjQxUE0gKzAyMDAsIEplc3BlciBEYW5n
YWFyZCBCcm91ZXINCj4gd3JvdGU6DQo+ID4gT24gRnJpLCAzMSBNYXkgMjAxOSAxOToyNToyNCAr
MDMwMCBJdmFuIEtob3JvbnpodWsgPA0KPiA+IGl2YW4ua2hvcm9uemh1a0BsaW5hcm8ub3JnPiB3
cm90ZToNCj4gPiANCj4gPiA+IE9uIEZyaSwgTWF5IDMxLCAyMDE5IGF0IDA1OjQ2OjQzUE0gKzAy
MDAsIEplc3BlciBEYW5nYWFyZCBCcm91ZXINCj4gPiA+IHdyb3RlOg0KPiA+ID4gPiBGcm9tIGJl
bG93IGNvZGUgc25pcHBldHMsIGl0IGxvb2tzIGxpa2UgeW91IG9ubHkgYWxsb2NhdGVkIDENCj4g
PiA+ID4gcGFnZV9wb29sDQo+ID4gPiA+IGFuZCBzaGFyaW5nIGl0IHdpdGggc2V2ZXJhbCBSWC1x
dWV1ZXMsIGFzIEkgZG9uJ3QgaGF2ZSB0aGUgZnVsbA0KPiA+ID4gPiBjb250ZXh0DQo+ID4gPiA+
IGFuZCBkb24ndCBrbm93IHRoaXMgZHJpdmVyLCBJIG1pZ2h0IGJlIHdyb25nPw0KPiA+ID4gPiAN
Cj4gPiA+ID4gVG8gYmUgY2xlYXIsIGEgcGFnZV9wb29sIG9iamVjdCBpcyBuZWVkZWQgcGVyIFJY
LXF1ZXVlLCBhcyBpdA0KPiA+ID4gPiBpcw0KPiA+ID4gPiBhY2Nlc3NpbmcgYSBzbWFsbCBSWCBw
YWdlIGNhY2hlICh3aGljaCBwcm90ZWN0ZWQgYnkNCj4gPiA+ID4gTkFQSS9zb2Z0aXJxKS4NCj4g
PiA+IA0KPiA+ID4gVGhlcmUgaXMgb25lIFJYIGludGVycnVwdCBhbmQgb25lIFJYIE5BUEkgZm9y
IGFsbCByeCBjaGFubmVscy4NCj4gPiANCj4gPiBTbywgd2hhdCBhcmUgeW91IHNheWluZz8NCj4g
PiANCj4gPiBZb3UgX2FyZV8gc2hhcmluZyB0aGUgcGFnZV9wb29sIGJldHdlZW4gc2V2ZXJhbCBS
WC1jaGFubmVscywgYnV0IGl0DQo+ID4gaXMNCj4gPiBzYWZlIGJlY2F1c2UgdGhpcyBoYXJkd2Fy
ZSBvbmx5IGhhdmUgb25lIFJYIGludGVycnVwdCArIE5BUEkNCj4gPiBpbnN0YW5jZT8/DQo+IA0K
PiBJIGNhbiBtaXNzIHNtdGggYnV0IGluIGNhc2Ugb2YgY3BzdyB0ZWNobmljYWxseSBpdCBtZWFu
czoNCj4gMSkgUlggaW50ZXJydXB0cyBhcmUgZGlzYWJsZWQgd2hpbGUgTkFQSSBpcyBzY2hlZHVs
ZWQsDQo+ICAgIG5vdCBmb3IgcGFydGljdWxhciBDUFUgb3IgY2hhbm5lbCwgYnV0IGF0IGFsbCwg
Zm9yIHdob2xlIGNwc3cNCj4gbW9kdWxlLg0KPiAyKSBSWCBjaGFubmVscyBhcmUgaGFuZGxlZCBv
bmUgYnkgb25lIGJ5IHByaW9yaXR5Lg0KDQpIaSBJdmFuLCBJIGdvdCBhIHNpbGx5IHF1ZXN0aW9u
Li4gDQoNCldoYXQgaXMgdGhlIHJlYXNvbiBiZWhpbmQgaGF2aW5nIG11bHRpcGxlIFJYIHJpbmdz
IGFuZCBvbmUgQ1BVL05BUEkNCmhhbmRsaW5nIGFsbCBvZiB0aGVtID8gcHJpb3JpdHkgPyBob3cg
ZG8geW91IHByaW9yaXRpZXMgPw0KDQo+IDMpIEFmdGVyIGFsbCBvZiB0aGVtIGhhbmRsZWQgYW5k
IG5vIG1vcmUgaW4gYnVkZ2V0IC0gaW50ZXJydXB0cyBhcmUNCj4gZW5hYmxlZC4NCj4gNCkgSWYg
cGFnZSBpcyByZXR1cm5lZCB0byB0aGUgcG9vbCwgYW5kIGl0J3Mgd2l0aGluIE5BUEksIG5vIHJh
Y2VzIGFzDQo+IGl0J3MNCj4gICAgcmV0dXJuZWQgcHJvdGVjdGVkIGJ5IHNvZnRpcnEuIElmIGl0
J3MgcmV0dXJuZWQgbm90IGluIHNvZnRpcnENCj4gaXQncyBwcm90ZWN0ZWQgDQo+ICAgIGJ5IHBy
b2R1Y2VyIGxvY2sgb2YgdGhlIHJpbmcuDQo+IA0KPiBQcm9iYWJseSBpdCdzIG5vdCBnb29kIGV4
YW1wbGUgZm9yIG90aGVycyBob3cgaXQgc2hvdWxkIGJlIHVzZWQsIG5vdA0KPiBhIGJpZw0KPiBw
cm9ibGVtIHRvIG1vdmUgaXQgdG8gc2VwYXJhdGUgcG9vbHMuLiwgZXZlbiBkb24ndCByZW1lbWJl
ciB3aHkgSQ0KPiBkZWNpZGVkIHRvDQo+IHVzZSBzaGFyZWQgcG9vbCwgdGhlcmUgd2FzIHNvbWUg
bW9yZSByZWFzb25zLi4uIG5lZWQgc2VhcmNoIGluDQo+IGhpc3RvcnkuDQo+IA0KPiA+IC0tIA0K
PiA+IEJlc3QgcmVnYXJkcywNCj4gPiAgSmVzcGVyIERhbmdhYXJkIEJyb3Vlcg0KPiA+ICBNU2Mu
Q1MsIFByaW5jaXBhbCBLZXJuZWwgRW5naW5lZXIgYXQgUmVkIEhhdA0KPiA+ICBMaW5rZWRJbjog
aHR0cDovL3d3dy5saW5rZWRpbi5jb20vaW4vYnJvdWVyDQo=
