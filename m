Date: Tue, 29 Jun 2021 12:25:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <YNtJjDlGoBcg4kgS@mit.edu>
References: <20210625191229.1752531-1-vgoyal@redhat.com>
	<BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
	<20210628131708.GA1803896@redhat.com>
	<1b446468-dcf8-9e21-58d3-c032686eeee5@redhat.com>
	<5d8f033c-eba2-7a8b-f19a-1005bbb615ea@schaufler-ca.com>
	<YNn4p+Zn444Sc4V+@work-vm>
	<a13f2861-7786-09f4-99a8-f0a5216d0fb1@schaufler-ca.com>
	<YNrhQ9XfcHTtM6QA@work-vm>
	<e6f9ed0d-c101-01df-3dff-85c1b38f9714@schaufler-ca.com>
MIME-Version: 1.0
In-Reply-To: <e6f9ed0d-c101-01df-3dff-85c1b38f9714@schaufler-ca.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [RFC PATCH 0/1] xattr: Allow user.* xattr on
 symlink/special files if caller has CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "berrange@redhat.com" <berrange@redhat.com>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Schaufler,
	Casey" <casey.schaufler@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jun 29, 2021 at 07:38:15AM -0700, Casey Schaufler wrote:
> > IMHO the biggest problem is it's badly defined when you want to actually
> > share filesystems between guests or between guests and the host.
> 
> Right. The filesystem isn't the right layer for mapping xattrs.

Well, let's enumerate the alternatives:

* Some kind of stackable LSM?
* Some kind of FUSE-like scheme?
* Adding an eBPF hook which can perform the mapping

The last may be the best bet, since different use cases can use
different eBPF programs.  The eBPF script can handle both the mapping
as well some kind of specialized access control with respect to what
entities are allowed set or get xattrs.

> >>> It would be lovely if there was something more granular, (e.g. allowing
> >>> user.NUMBER. or trusted.NUMBER. to be used by this particular guest).
> >> We can't do that without breaking the "kernels aren't container aware"
> >> mandate.

eBPF scripts, since they are supplied by the user *can* be container
aware.  :-)

						- Ted

