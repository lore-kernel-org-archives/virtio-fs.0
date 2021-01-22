DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:from:date:message-id:subject:to;
	bh=yhaf3fT5Kf4lDvCw364/7ZHuJYstIJd2PDy0w9/goxA=;
	b=Iyw0Y4FAmZ4ib9OasO92fGvzNnxHOZfTbwabbv/H5CFqTXcNC8mSbLHsDXbo5r3unQ
	eORiKI1CnTcY7fC0nhoWQBGUUFE1/C9mthw58nOWiEUVbSqnaO0qPJTQc4pWz+Ry9ODX
	dTve6Kb9tvag3hycEBPcXpl0MVbIy8+lI+rY15wkQkrGZB922b3WftJLaqzIyjKeR/6c
	tiWnINNH0jN1IsVqXq8tsogq4HPCFvCwjXKq88SikZlcTKdp913nk4FH7w1J6Z0FK3kH
	EhRAqK2GmIMLrkZ72N06Ij7TZ9c0r3ASRNZH165V7Q+AltCNtMIIe10KNzWt6KOeeWVk
	IXIw==
MIME-Version: 1.0
From: Eric Ernst <eric.g.ernst@gmail.com>
Date: Fri, 22 Jan 2021 08:58:05 -0800
Message-ID: <CAAQbG+U9m91sxsm9swLB7gYNh3NT47Z0kb9LbgEZXUMV65StLQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000002ac5b105b98018a8"
Subject: [Virtio-fs] Lack of inotify for virtio-fs backed files/directories
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--0000000000002ac5b105b98018a8
Content-Type: text/plain; charset="UTF-8"

Hey ya'll,

As highlighted nicely at [1], a common pattern in Kubernetes is to watch
for changes to files/directories passed in as Configmaps or secrets.
Sidecars typically use inotify to watch for changes and then signal the
primary container or perform other changes based on the reconfiguration.

In the context of Kata, these files/dirs are passed in utilizing virtio-fs.
Since FUSE itself doesn't support inotify, this pattern will fail. I'm
looking at ways to work-around this gap, including:

1) documenting this as a compatibility limitation ("don't do this!").
2) suggesting end-users modify their sidecars and utilize poll
3) doing an inotify on the host, and when changes are identified, notify
the guest agent who can then modify the files on disk to trigger an inotify
4) Working on contributing to libfuse in order to add inotify support.

(4) is the right thing, but will take quite a bit of time before it can be
used. I'm curious if other folks have suggestions for workarounds (I don't
like any of the ones I suggested), and if anyone has taken a look at (4)?

Thanks,
Eric

[1] - https://github.com/kata-containers/runtime/issues/1505

--0000000000002ac5b105b98018a8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hey ya&#39;ll,<div><br></div><div>As high=
lighted nicely at [1], a common pattern in Kubernetes is to watch for chang=
es to files/directories passed in as Configmaps or secrets. Sidecars=C2=A0t=
ypically use inotify to watch for changes and then signal the primary conta=
iner or perform other changes based on the reconfiguration.</div><div><br><=
/div><div>In the context of Kata, these files/dirs are passed in utilizing =
virtio-fs. Since FUSE itself doesn&#39;t support inotify, this pattern will=
 fail. I&#39;m looking at ways to work-around this gap, including:</div><di=
v><br></div><div>1) documenting this as a compatibility limitation (&quot;d=
on&#39;t do this!&quot;).</div><div>2) suggesting end-users modify their si=
decars and utilize poll</div><div>3) doing an inotify on the host, and when=
 changes are identified, notify the guest agent who can then modify the fil=
es on disk to trigger an inotify</div><div>4) Working on contributing to li=
bfuse in order to add inotify support.</div><div><br></div><div>(4) is the =
right thing, but will take quite a bit of time before it can be used. I&#39=
;m curious if other folks have suggestions for workarounds (I don&#39;t lik=
e any of the ones I suggested), and if anyone has taken a look at (4)?</div=
><div><br></div><div>Thanks,</div><div>Eric</div><div><br></div><div>[1] -=
=C2=A0<a href=3D"https://github.com/kata-containers/runtime/issues/1505">ht=
tps://github.com/kata-containers/runtime/issues/1505</a></div></div></div>

--0000000000002ac5b105b98018a8--

