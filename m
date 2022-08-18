Return-Path: <okada.yusuke@fujitsu.com>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
 t=1660850000; x=1692386000;
 h=from:to:cc:subject:date:message-id:references:
 in-reply-to:content-transfer-encoding:mime-version;
 bh=Mwlgz96DBJ1qJPlk26DDpK/DHACm6XkHvPffvu7SZY0=;
 b=F4My8LlrwktkiJ6IJVrQu5KkMsAEYXId7HTxicM2DMCSIe+UQMVD/jB6
 CJu7BipWCx3U/I68bvR87ZOFZj+eu3AeFuNpWthgkE+6vmfNYrmVmkex4
 8nw8eKINkyN6hZzqXPGLbcMoRHnQWTYj71FX/pCSAYC1DH6zrBcDFIbGX
 O8/XkenT1ivWGI75A0GY7dgCVMhhRfIxdRwl+EAUPi+lyJCHhx3Q8aBpX
 +n0OTElhjiyM0hsf/M9R+mYuQcFmcg6Ut2Rf1mGb+Bq2ohjPy/HDiTuz6
 mJzbU/iASLIirlnmasYEwQVuacwmi7nCPbEpORPTQiEjKed/P19ef1GGa w==
From: "okada.yusuke@fujitsu.com" <okada.yusuke@fujitsu.com>
Date: Thu, 18 Aug 2022 19:12:13 +0000
Message-ID: <TYYPR01MB668335D98A5849C0B759DDB79D6D9@TYYPR01MB6683.jpnprd01.prod.outlook.com>
References: <20220818184618.2205172-1-yokada.996@gmail.com>
In-Reply-To: <20220818184618.2205172-1-yokada.996@gmail.com>
MIME-Version: 1.0
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: use g_date_time_get_microsecond
 to get subsecond
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Yusuke Okada <yokada.996@gmail.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "open list:virtiofs" <virtio-fs@redhat.com>

Hi,=0A=0ABecause the first mail doesn't include "From" line in its body, I =
sent it again.=0ASorry for bothering.=0A=0ABest Regards,=0AYusuke Okada=0A

