Return-Path: <farosas@linux.ibm.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com;
 h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=tJQdN3T5ErtERhRZLb/iXu1z8z2f47+ktYkUX4v4VDM=;
 b=OqS141MSqZh9jjBhld9S+dPgqVSinTbkP899RwEksVJuHHHhtxfDwlNJHtfmM75K1pC0
 C/0sRH9X4aa08QNgA4X+ZpR6F6yutF9ZiELVIWleSP6JkeehDCrv4D0Tvcudow0P7nfg
 Lli/mOe97qkE9uO8DUFu9+A5Ws36JqDiiI/YuNp10blDG/1SwJB3O4EL/9syP1ibEanR
 RjmxV7vtD4H7uGvmjMWtdYlS/Iqb5UdouxXNEZgOVRVKk8hNX28GCpjtUFLhhPgRzrWG
 FCAFaa7DAz4OgfcVtUPKoArrAGXtJTL1DQKnur5JydmYrPlr3AgxRhyMuQpD+tq+pPu/ vA==
From: Fabiano Rosas <farosas@linux.ibm.com>
In-Reply-To: <YoyuwoswrAKvzFIi@stefanha-x1.localdomain>
References: <YoyuwoswrAKvzFIi@stefanha-x1.localdomain>
Date: Tue, 24 May 2022 16:40:37 -0300
Message-ID: <87v8tug1my.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] virtio-fs-ci license file added
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

Stefan Hajnoczi <stefanha@redhat.com> writes:

> Hi Fabiano,
> I wanted to let you know that I have added the GPLv2 license text to the
> virtio-fs-ci.git repo so GitLab can detect the license.
>
> The code contributions you made were in files that already carried a
> GPL-2.0-or-later license header, so there is no change in the licensing
> of your code, except for a .config snippet you contributed without an
> explicit license header.
>
> If you want to specify an explicit license for the .config file or have
> any questions, please let me know. Thanks!
>
> Stefan

Hi Stefan, thanks for reaching out.

I think it's fine to leave the config snippet without a license header.

Thanks

