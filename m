Return-Path: <hreitz@redhat.com>
Message-ID: <4109ebd0-ccd7-9e3c-8a32-b4db998d8e39@redhat.com>
Date: Fri, 21 Jul 2023 18:09:13 +0200
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-4-hreitz@redhat.com>
 <CAJaqyWdAjbJxFE7BTzw6zYrr9_80qsxWrvq=kXjKMDTMtYKOKg@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAJaqyWdAjbJxFE7BTzw6zYrr9_80qsxWrvq=kXjKMDTMtYKOKg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 3/4] vhost: Add high-level state
 save/load functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>

On 21.07.23 17:18, Eugenio Perez Martin wrote:
> On Wed, Jul 12, 2023 at 1:17 PM Hanna Czenczek <hreitz@redhat.com> wrote:
>> vhost_save_backend_state() and vhost_load_backend_state() can be used by
>> vhost front-ends to easily save and load the back-end's state to/from
>> the migration stream.
>>
>> Because we do not know the full state size ahead of time,
>> vhost_save_backend_state() simply reads the data in 1 MB chunks, and
>> writes each chunk consecutively into the migration stream, prefixed by
>> its length.  EOF is indicated by a 0-length chunk.
>>
>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
>> ---
>>   include/hw/virtio/vhost.h |  35 +++++++
>>   hw/virtio/vhost.c         | 204 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 239 insertions(+)

[...]

>> +int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp)
>> +{
>> +    size_t transfer_buf_size = 0;
>> +    void *transfer_buf = NULL;
>> +    g_autoptr(GError) g_err = NULL;
>> +    int pipe_fds[2], read_fd = -1, write_fd = -1, reply_fd = -1;
>> +    int ret;

[...]

>> +    ret = 0;
>> +fail:
>> +    g_free(transfer_buf);
> Nitpick, but transfer_buf could have the g_autofree parameter.

Ah, sure, thanks!

Hanna

