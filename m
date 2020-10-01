Date: Thu, 1 Oct 2020 14:51:29 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201001135129.GG2807@work-vm>
References: <20200929185015.GG220516@redhat.com>
	<CAOQ4uxgMeWF_vitenBY6_N3Eu-ix92q8AO5ckDAF+SVxHTBXXw@mail.gmail.com>
	<CAJfpegtH0TruLCnG_YJ8aUBHh7k5sqN_wVEegvDPJOoDcmwLSQ@mail.gmail.com>
	<CAOQ4uxiity6zAW__Y+T=o+GHkzxo=fnVj+21Z8cRjdvFWbauRQ@mail.gmail.com>
	<dfa0dbea-7046-0852-60c6-39bc24f24314@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <dfa0dbea-7046-0852-60c6-39bc24f24314@gmail.com>
Subject: Re: [Virtio-fs] Kudos: productivity boost using virtio-fs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
> Though it's likely been written before:
>=20
> Virtio-fs is a wonderful productivity boost in development environments
> in which unrelated deadlocks, crashes and hard-lockups happen.=A0=A0 Why?=
=A0
> Because the underlying file system is never corrupted (though individual
> file contents may be, the file system itself is protected).=A0=A0 For
> example, using btrfs' snapshot ability in the underlying file system and
> comparing 'before and after' crashes creates a powerful debugging tool.

Thanks!

I'm curious, can you describe a bit more about how you're using it with
btrfs - I don't think we've had anyone describe that before.
(We mostly use it with overlayfs via the various container tools).

Dave

> I suspect most folks involved in virtio-fs know this, but it's worth
> putting in the record for new folks.
>=20
> Harry
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

