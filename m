DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1630684892; bh=lz1PwBXHGViBIV61NAkWI89twfzj/A5LlwKuVkadHXo=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=dCnWZn3DXEbyNrX74tvC249Kyxs1SOZjEgRgfyQUE8g1ySGAMDOXo6mtEHj6BWGgpnRHRh5DE9mTYnRXPSFwgTTSRsIRcbsy3YBcJnNlmnyqIBEywDKGzw2MY7kd+81GgWiorSuskUcz0bT6DQof68pI81lbG/9FyYxCPNQMbhFNMcpkV59O4FjqXerWiO3MUWB08XJuBhJiHJITVnXC72dBl4VLjxNZ0PZdHDat/lhOlTIsY63vseEvb1lM+lKCmK2y1cO5mx3cB8rtpUbW2nXd2/ZIEBneGmuFynMnf6lcqP+YmA3u2NY1hxUBLoPCaDANxBRQdG8/F2l1hkWZrA==
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<YTDyE9wVQQBxS77r@redhat.com>
	<CAHc6FU4ytU5eo4bmJcL6MW+qJZAtYTX0=wTZnv4myhDBv-qZHQ@mail.gmail.com>
	<CAHc6FU5quZWQtZ3fRfM_ZseUsweEbJA0aAkZvQEF5u9MJhrqdQ@mail.gmail.com>
	<CAPL3RVH9MDoDAdiZ-nm3a4BgmRyZJUc_PV_MpsEWiuh6QPi+pA@mail.gmail.com>
	<YTJCjGH0V5yzMnQB@redhat.com>
	<CAPL3RVFB67-AqZrjjfxueQF1Jw=LmKWzCk3Ur94EjUotYMw0AA@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <95fd9166-c809-5a2e-fb40-aba253c9faa6@schaufler-ca.com>
Date: Fri, 3 Sep 2021 09:01:30 -0700
MIME-Version: 1.0
In-Reply-To: <CAPL3RVFB67-AqZrjjfxueQF1Jw=LmKWzCk3Ur94EjUotYMw0AA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH 3/1] xfstests: generic/062: Do not run on
	newer kernels
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Bruce Fields <bfields@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, stephen.smalley.work@gmail.com, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, fstests <fstests@vger.kernel.org>, virtio-fs@redhat.com, Casey Schaufler <casey.schaufler@intel.com>, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>

On 9/3/2021 8:50 AM, Bruce Fields wrote:
> On Fri, Sep 3, 2021 at 11:43 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Fri, Sep 03, 2021 at 10:42:34AM -0400, Bruce Fields wrote:
>>> Well, we could also look at supporting trusted.* xattrs over NFS.  I
>>> don't know much about them, but it looks like it wouldn't be a lot of
>>> work to specify, especially now that we've already got user xattrs?
>>> We'd just write a new internet draft that refers to the existing
>>> user.* xattr draft for most of the details.
>> Will be nice if we can support trusted.* xattrs on NFS.
> Maybe I should start a separate thread for that.  Who would need to be
> on it to be sure we get this right?

I would like to be included. It would probably be a good idea to
include the LSM list, linux-security-module@vger.kernel.org. I'll leave
the networking and filesystem folks to speak for themselves.

>
> --b.
>

