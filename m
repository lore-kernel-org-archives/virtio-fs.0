Date: Tue, 20 Oct 2020 11:09:22 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201020100922.GF140014@stefanha-x1.localdomain>
References: <20201014180209.49299-1-dgilbert@redhat.com>
	<20201014180209.49299-6-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lIrNkN/7tmsD/ALM"
Content-Disposition: inline
In-Reply-To: <20201014180209.49299-6-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 5/5] tools/virtiofsd: xattr name
	mappings: Simple 'map'
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--lIrNkN/7tmsD/ALM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 14, 2020 at 07:02:09PM +0100, Dr. David Alan Gilbert (git) wrote:
> +static XattrMapEntry *parse_xattrmap_map(const char *rule,
> +                                         XattrMapEntry *map,
> +                                         size_t *nentries)
> +{
> +    char sep = *rule++;
> +    const char *tmp;
> +    char *key;
> +    char *prefix;
> +    XattrMapEntry tmp_entry;
> +
> +    /* At start of 'key' field */
> +    tmp = strchr(rule, sep);

Missing sep == '\0' check. The strchr(3) man page says:

  The terminating null byte is considered part of the string, so that if
  c is specified as '\0', these functions return a pointer to the
  terminator.

So the code in this patch will eventually access beyond the end of the
string:

  rule = tmp + 1; <-- tmp is already at the NUL terminator

--lIrNkN/7tmsD/ALM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+Ot1EACgkQnKSrs4Gr
c8joDwf+LjvGfFhjtzgTWfk0XXiPUPH2CZKehHLqMydxgUVhtEwSASvy/0VE8DQV
f4qGlYyDmMwMKrOBytazuHu4bc9mdSdB0NuG24gaDLB/vajiX8gbXfSchTV5rXGz
QDnjZbYLqB9b7KbrYWVpDKhYXtqq035xQY1zdjAvAl1aRy1AlCk+yc2M8KRpnkzE
EOGEMBjRoX9dmo54WhZi93VTsJhIb7j/kRAhISrEjDjXHcXE2QtANswX9tnjWQmn
mNsorHNQ71MVe00iLNWsaOLcTdkmFBU93SwSol5exXbOK1cFwcqNE8y/XAJVQFWE
1okVx/sV9Y8LdtelwivbdM2MHlv80Q==
=vlQF
-----END PGP SIGNATURE-----

--lIrNkN/7tmsD/ALM--

