Return-Path: <hreitz@redhat.com>
Message-ID: <59879fe8-c4c2-911c-89cd-9673c4879957@redhat.com>
Date: Thu, 20 Jul 2023 13:32:10 +0200
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-2-hreitz@redhat.com> <20230718161256.GK44841@fedora>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <20230718161256.GK44841@fedora>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 1/4] vhost-user.rst: Migrating
 back-end-internal state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, qemu-devel@nongnu.org, "Michael S . Tsirkin" <mst@redhat.com>

On 18.07.23 18:12, Stefan Hajnoczi wrote:
> On Wed, Jul 12, 2023 at 01:16:59PM +0200, Hanna Czenczek wrote:
>> @@ -1471,6 +1511,53 @@ Front-end message types
>>     before.  The back-end must again begin processing rings that are not
>>     stopped, and it may resume background operations.
>>   
>> +``VHOST_USER_SET_DEVICE_STATE_FD``
>> +  :id: 43
>> +  :equivalent ioctl: N/A
>> +  :request payload: device state transfer parameters
> Where are these defined?

...an excellent question.  Right, I forgot to add them!

