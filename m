Return-Path: <thuth@redhat.com>
Message-ID: <3b6c8e16-3712-3402-3ab2-17bf53ec64a8@redhat.com>
Date: Tue, 5 Jul 2022 09:48:32 +0200
MIME-Version: 1.0
References: <BY5PR11MB42911D5BF55D9FAF501F64F68D819@BY5PR11MB4291.namprd11.prod.outlook.com>
From: Thomas Huth <thuth@redhat.com>
In-Reply-To: <BY5PR11MB42911D5BF55D9FAF501F64F68D819@BY5PR11MB4291.namprd11.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [Qemu] how to use viriofs in qemu without NUMA
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Zhao, Shirley" <shirley.zhao@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Cc: virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>

On 05/07/2022 03.02, Zhao, Shirley wrote:
> Hi, all,
> 
> I want to use virtiofs to share folder between host and guest.
> 
>  From the guide, it must set the NUMA node. 
> https://virtio-fs.gitlab.io/howto-qemu.html 
> 
> But my guest doesn’t support NUMA.
> 
> Is there any guide to use qemu + virtiofs without NUMA?
> 
> Or does qemu have any plan to support it?

  Hi!

At least on s390x, you can also specify the memory backend via the -machine 
option instead of using the -numa option, e.g.:

  qemu-system-s390x -machine memory-backend=mem \
   -object memory-backend-file,id=mem,...

Not sure whether that works on other architectures, too, though. Stefan, 
David, do you know?

  Thomas

