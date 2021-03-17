From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <810089e0-3a09-0d8f-9f8e-be5b3ac70587@redhat.com>
Date: Wed, 17 Mar 2021 13:12:01 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] Question about sg_count_fuse_req() in
	linux/fs/fuse/virtio_fs.c
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

Hi,

I've been familiarizing myself with the virtiofs guest kernel module and 
I'm trying to better understand how virtiofs maps a FUSE request into 
scattergather lists.

sg_count_fuse_req() starts knowing that there will be at least one in 
header, as shown here (which makes sense):

         unsigned int size, total_sgs = 1 /* fuse_in_header */;

However, I'm confused about this snippet right beneath it:

         if (args->in_numargs - args->in_pages)
                 total_sgs += 1;

What is the significance of the sg that is needed in the cases where 
this branch is taken? I'm not sure what its relationship is with 
args->in_numargs since it will increment total_sgs regardless 
args->in_numargs is 3, 2, or even 1 if args->in_pages is false.

Especially since the block right below it counts pages if args->in_pages 
is true:

         if (args->in_pages) {
                 size = args->in_args[args->in_numargs - 1].size;
                 total_sgs += sg_count_fuse_pages(ap->descs, ap->num_pages,
                                                  size);
         }

The rest of the routine goes on similarly but for the 'out' components.

I doubt incrementing 'total_sgs' in the first if-statement I showed 
above is vestigial, I just think my mental model of what is happening 
here is incomplete.

Any clarification is much appreciated!

Connor

