Return-Path: <prvs=3454adc0d=anthony.perard@citrix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
 d=citrix.com; s=securemail; t=1671459078;
 h=date:from:to:cc:subject:message-id:references:
 mime-version:content-transfer-encoding:in-reply-to;
 bh=bkhL5i1Zpu2u0dNJ8rDflE68+bM9GeYGaMZ8cE7WyBg=;
 b=ag3EWW/3hJfp0gZaKf1a8UVazwN+m1snTDjJaO+MERKNY/iQm/q3ydmF
 GaDoO3Xv7ibnFluc34nD5H6/XkdiTxDOyxFRAEwPm4SvET+DLVdewGPut
 kG64kyQ++HMDKYhGIz4Wnjrp3HGDmXhgzYCQOjVj8F9ZaImsaCUYWQMPs E=
Date: Mon, 19 Dec 2022 14:10:04 +0000
From: Anthony PERARD <anthony.perard@citrix.com>
Message-ID: <Y6BwvATqB0ka7qys@perard.uk.xensource.com>
References: <20221219130205.687815-1-berrange@redhat.com>
 <20221219130205.687815-3-berrange@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221219130205.687815-3-berrange@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 2/6] hw/xen: use G_GNUC_PRINTF/SCANF for
 various functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-ppc@nongnu.org, xen-devel@lists.xenproject.org, Laurent Vivier <lvivier@redhat.com>, Markus Armbruster <armbru@redhat.com>, Daniel Henrique
 Barboza <danielhb413@gmail.com>, virtio-fs@redhat.com, Michael Roth <michael.roth@amd.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, qemu-block@nongnu.org, Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org, Paul Durrant <paul@xen.org>, David Gibson <david@gibson.dropbear.id.au>, =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>, John Snow <jsnow@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefano Stabellini <sstabellini@kernel.org>, Gerd
 Hoffmann <kraxel@redhat.com>, Greg Kurz <groug@kaod.org>, Thomas Huth <thuth@redhat.com>

On Mon, Dec 19, 2022 at 08:02:01AM -0500, Daniel P. Berrang=E9 wrote:
> Signed-off-by: Daniel P. Berrang=E9 <berrange@redhat.com>

Acked-by: Anthony PERARD <anthony.perard@citrix.com>

Thanks,

--=20
Anthony PERARD

