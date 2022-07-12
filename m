Return-Path: <vgoyal@redhat.com>
Date: Tue, 12 Jul 2022 08:37:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Ys1rH9Mn6fKh35p7@redhat.com>
References: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Pra.. Dew.." <linux_learner@outlook.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Fri, Jul 08, 2022 at 08:18:19PM +0000, Pra.. Dew.. wrote:
> We have been able to setup virtiofs between guest and host (QEMU 6.2/Linux 5.15). We run virtiofsd as a non-root user in the host. We did not want to run it as a root user in order to minimize the attack surface. We run it as a virtiofs user. When we create a file in the shared folder, the permission of the file is virtiofs user and virtiofs group. When we read that file from the guest it shows virtiofs user (only the uid) and nobody group. The goal is to restrict the access of the file to a few services in the guest (not give access to all services). We tried to create a group in the guest and tried to move the file in the new group. However chown gives "bad descriptor." Is there a better way of doing this? Any input is really appreciated. Thank you so much!

Hi,

Are you using C version of virtiofsd (from qemu) or rust version of
virtiofsd found here.

https://gitlab.com/virtio-fs/virtiofsd

I would recommend using rust version of virtiofsd now and as German
suggested in another email, let unprivileged user launch a user namespace
and run virtiofsd inside that. That should allow you to do arbitrary
uid/gid switching inside guest.

Thanks
Vivek

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

