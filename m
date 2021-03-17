DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=WEz1d/e2FD0Bb0jqfPmPixKcTTK0zElGy1qtD/uutw4=;
	b=e6VZHa0ehiWNW2azoEfh57Fe81
	w6yfNMssKw9JSlLqXclxE7MyqDhVyzx+effkHOjH5VKSqSOgpfuQ4QrbvTYidGGa0QycvE2Vyt3px
	7QD6Tc+H4jUVovMSFjI3fQIK4/Ag9zUgfksL2LcrMgVMU8iQLO1pwdR2HG/NTOGTSlsKPmtfEG14C
	y8DXZpa3eWLKj5AGh3QrbxiLAI61kwT1CCEVgUMU27EWTI07LdHiRG9pmIpmHK4IajXLWDtSnv4F4
	UnJs8B82GxvoR89jJl7Gc9MTENOZZsFkzFqNtnJAOqqJwTZmT81gV0sOWJOIShgnDZryqAtZO+D4o
	I+RbA6Dx49JlFrOSlZt+eEwm3rNSGZOhSZCABiFkZ5FYb+/oQdE4CdK1tBDr4MYmKNzif9Srftxs0
	+L8OB0RAuOcaPrcUNz3cNkbROR9qyp693T5xfXA0C85y81Hgn66FJ2f1bJQErOlmo7tsmtRIpNQpC
	LBARVO2qVjwxrNh+LzygwlwbWIiNRJDmojVvpLTKmn3Pp5V6hlG9UvzGijGSRrsrVZqpetfmAJXmi
	a8QHHAN4YRAzuom7qzQOIMgThHsfVgpznONXIA/2g+8NoUc9uVNw9s2qedFxhKYP1mCf+Mc7JxBga
	KCljkb/oKljv3bIMZKQlzWgMMO6mWz9vvSgHpOL9Y=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Wed, 17 Mar 2021 12:49:37 +0100
Message-ID: <1709993.NBFj2RoZ23@silver>
In-Reply-To: <YFHUbEdszo4nursr@stefanha-x1.localdomain>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
	<CAFQAk7hCqSMMfRjUO8vtK-B2cKxJZZTJgSDAbRycd1AOSktM_w@mail.gmail.com>
	<YFHUbEdszo4nursr@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [External] Re: [RFC PATCH 0/9] Support for
	Virtio-fs daemon crash reconnection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Daniel P. Berrange" <berrange@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Xie Yongji <xieyongji@bytedance.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@gmail.com>

On Mittwoch, 17. M=E4rz 2021 11:05:32 CET Stefan Hajnoczi wrote:
> On Fri, Dec 18, 2020 at 05:39:34PM +0800, Jiachen Zhang wrote:
> > Thanks for the suggestions. Actually, we choose to save all state
> > information to QEMU because a virtiofsd has the same lifecycle as its
> > QEMU master. However, saving things to a file do avoid communication wi=
th
> > QEMU, and we no longer need to increase the complexity of vhost-user
> > protocol. The suggestion to save fds to the systemd is also very
> > reasonable
> > if we don't consider the lifecycle issues, we will try it.
>=20
> Hi,
> We recently discussed crash recovery in the virtio-fs bi-weekly call and
> I read some of this email thread because it's a topic I'm interested in.

I just had a quick fly over the patches so far. Shouldn't there be some kin=
d=20
of constraint for an automatic reconnection feature after a crash to preven=
t=20
this being exploited by ROP brute force attacks?

E.g. adding some (maybe continuously increasing) delay and/or limiting the =

amount of reconnects within a certain time frame would come to my mind.

Best regards,
Christian Schoenebeck



