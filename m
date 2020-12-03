Date: Thu, 3 Dec 2020 15:08:30 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201203200830.GD3266@redhat.com>
References: <04959049-62bf-c7dc-70b5-aacbc649c474@gmail.com>
	<20201119183841.GB3300@redhat.com>
	<20201119184436.GC3300@redhat.com>
	<20201119194424.GD3300@redhat.com>
	<d6a20a5e-3da3-b73b-03b6-24eb044c05a6@redhat.com>
	<eecb8c4e-9fd9-39ba-024b-c35953e769ef@gmail.com>
	<20201120185557.GC3105@redhat.com>
	<34ee3c42-8948-13a7-9c3f-8417bb4e948e@gmail.com>
	<20201130144955.GA14328@redhat.com>
	<6e058959-20e1-fdf5-1e34-4de249111cf8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e058959-20e1-fdf5-1e34-4de249111cf8@gmail.com>
Subject: Re: [Virtio-fs] restorcon/SELinux virtiofs question
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

On Thu, Dec 03, 2020 at 12:24:04PM -0600, Harry G. Coin wrote:
> During further testing, and with the selinux patch above in place,
> during an ordinary dnf package install, (virtiofs root), I see this:
> 
> ...
> 
>   Running scriptlet:
> bind-dyndb-ldap-11.3-5.fc33.x86_64                   13/14
> 
>   Installing       :
> freeipa-server-dns-4.8.10-6.fc33.noarch              14/14
>   Running scriptlet:
> freeipa-server-dns-4.8.10-6.fc33.noarch              14/14
> /usr/lib/tmpfiles.d/krb5-krb5kdc.conf:1: Line references path below
> legacy directory /var/run/, updating /var/run/krb5kdc → /run/krb5kdc;
> please update the tmpfiles.d/ drop-in file accordingly.
> Cannot set file attribute for '/var/log/journal', value=0x00800000,
> mask=0x00800000, ignoring: Function not implemented
> Cannot set file attribute for
> '/var/log/journal/659f950795794c76814a499623c1ddf1', value=0x00800000,
> mask=0x00800000, ignoring: Function not implemented

virtiofsd/fuse is returning error "-ENOSYS" for some operation. You
can try running virtiofsd with option "-d" which enables debug. 
(And remove --daemonize option). That will log all the messages coming
to virtiofsd and it will give clue what operation returned -ENOSYS

strace inside guest might help too. (With the option of tracing all
children).

Thanks
Vivek

> 
>   Verifying        :
> bind-32:9.11.24-2.fc33.x86_64                         1/14
>   Verifying        :
> bind-dnssec-doc-32:9.11.24-2.fc33.noarch              2/14
> 
> ...
> 
> Any ideas?
> 
> Harry
> 
> 

