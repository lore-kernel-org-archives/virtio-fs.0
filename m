Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1695304603; x=1695909403;
 darn=redhat.com; 
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=aLlclXdwLtN4CPnz5WCduKG/f/78DAzPIWKjXDxK/qc=;
 b=EeETOCwGeA1VDEqfpytEUkp1og3AOa5WOH7yQylcpDXOCSVKNG/C8eD6Iruw7Emqcr
 jZ/Yv/66dh30thpKbLr0Al4936K2IfXEqXy4SJf0rfVwLAGNzmvuU3P8Z5GFwqf+Oe+B
 xKgdxjxJgmS6qSc/+zhtGGrRuolYRnxSpZiRyV4CsCIBeYKvEs9hHeBW3ucWenQwSeMf
 Vnwar4Ymf6dJ2r2A8tGr07v4PjN2p3uNZnFTSK1SCJfZ96wxU0Zyor/Q4VRLM2V5ADNR
 +2RoQVoEQEAHU7y4pXm+49AHXw8Bd5SNSh/3AfZ+rfGuig2iSRYzaeR3PP78Jat0jGaM
 +olQ==
Message-ID: <32d74d08-f6f1-4958-aab7-03144efcbc82@daynix.com>
Date: Thu, 21 Sep 2023 22:56:38 +0900
MIME-Version: 1.0
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
 <20221110100629.61496-8-akihiko.odaki@daynix.com>
 <20230921125828.GA3860191@fedora>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20230921125828.GA3860191@fedora>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 07/10] virtiofsd: Use
 qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>

On 2023/09/21 21:58, Stefan Hajnoczi wrote:
> On Thu, Nov 10, 2022 at 07:06:26PM +0900, Akihiko Odaki wrote:
>> qemu_get_runtime_dir() is used to construct the path to a lock file.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   tools/virtiofsd/fuse_virtio.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
>> index 9368e292e4..b9eeed85e6 100644
>> --- a/tools/virtiofsd/fuse_virtio.c
>> +++ b/tools/virtiofsd/fuse_virtio.c
>> @@ -901,12 +901,12 @@ static bool fv_socket_lock(struct fuse_session *se)
>>   {
>>       g_autofree gchar *sk_name = NULL;
>>       g_autofree gchar *pidfile = NULL;
>> -    g_autofree gchar *state = NULL;
>> +    g_autofree gchar *run = NULL;
>>       g_autofree gchar *dir = NULL;
>>       Error *local_err = NULL;
>>   
>> -    state = qemu_get_local_state_dir();
>> -    dir = g_build_filename(state, "run", "virtiofsd", NULL);
>> +    run = qemu_get_runtime_dir();
>> +    dir = g_build_filename(run, "virtiofsd", NULL);
>>   
>>       if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
>>           fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s\n",
> 
> tools/virtiofsd/ no longer exists. Which version of QEMU did you develop against?
> 
> commit e0dc2631ec4ac718ebe22ddea0ab25524eb37b0e
> Author: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Date:   Wed Jan 18 12:11:51 2023 +0000
> 
>      virtiofsd: Remove source
> 
> Stefan

It is an old version of the series. You can find the latest version at:
https://patchew.org/QEMU/20230921075425.16738-1-akihiko.odaki@daynix.com/

Regards,
Akihiko Odaki

