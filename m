DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=subject:to:references:from:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=dC/nvXG95TbR/eHqWGrqXBoFZUllfw1ZKehfCU5kEZU=;
	b=hEnm9142382z6RLtSqTZZRBpK+/yyOfzVn1MjSClVpWjeXaQUo6TtDzSdHbIBAXjDD
	11i6amOURhOEC0Z4pQE++WH0TDQIoqmp8gtD48FFmomNxvMCDW+zCc09nJ5ZhsxGPPgN
	79WfZnTv3g4xQIOFQnyb7u1GRrU//BNONU3BxIny4wmi/guY9tY0rDlU6LOPkCI9mHAE
	ZYFjP6ofIKTLqVKXEw/illK4W+ryHAxvNlfz0f+MHlIthDHCOyg2b+Ys11demB9gwINU
	V5P6iVsCccmIwbjs/q67C4C1KIRHnfYDCGdLUB42S6uztW37bF2bkl8oLAXOyU4n53p9
	HsEw==
References: <a3ba5685-54b0-006d-abb4-ca3340be33ec@gmail.com>
	<3c0acb1d-eef1-0289-3c48-dbc19a735b96@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <2af4770c-2148-ec0f-bcad-0b03829476da@gmail.com>
Date: Mon, 21 Dec 2020 14:57:04 -0600
MIME-Version: 1.0
In-Reply-To: <3c0acb1d-eef1-0289-3c48-dbc19a735b96@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] What did I miss / SELinux avcs needed for virtiofs
 root.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com


On 12/21/20 2:08 PM, Daniel Walsh wrote:
> On 12/18/20 12:06, Harry G. Coin wrote:
>> Below is the roster of avc / SELinux corrections needed to have a
>> virtiofs root on Fedora 33.  There has got to be an easier way.  Any
>> ideas?
>>
>> I installed Fedora workstation 33 to a qcow2 file.  Then in the VM
>> mounted an empty virtiofs backed by xattr enabled host in tmp, did a  cp
>> -a /, /home and /boot to the virtio fs, added files to dracut to build
>> an initramfs that permitted root mounting on the default kernel, and a
>> script to generate a link to the latest kernel with an unchanging name
>> in /boot for easy direct kernel booting in the vm.  then I booted and
>> rebooted each time doing 'audit2allow -a -M fileX;semodule -i
>> fileX.pp;reboot' until there were no new avcs recorded in the boot
>> process.
>>
>> Initially I had to add init=/bin/bash to the command line there were so
>> many avc's the system wouldn't boot.   The following are enough to get
>> to a console prompt in a GUI log in without throwing further AVC's.
>> Obviously it's the 'unlabeled-t' that's at issue.  This is with the
>>
>> (fsuse xattr virtiofs (system_u object_r fs_t ((s0) (s0))))
>>
>> in place.  Did I miss a mount option?  This shouldn't have been so hard,
>> I feel like I must have missed something.  What?
>>
>> ----
>>
>>
>> #============= NetworkManager_t ==============
>>
>> allow NetworkManager_t unlabeled_t:file { map rename unlink write };
>>
>> allow NetworkManager_t unlabeled_t:lnk_file read;
>>
>> allow NetworkManager_t unlabeled_t:sock_file write;
>>
>> #============= abrt_dump_oops_t ==============
>>
>> allow abrt_dump_oops_t unlabeled_t:sock_file write;
>>
>> #============= abrt_t ==============
>>
>> allow abrt_t unlabeled_t:dir { add_name read remove_name write };
>>
>> allow abrt_t unlabeled_t:file { create map open read };
>>
>> allow abrt_t unlabeled_t:lnk_file create;
>>
>> allow abrt_t unlabeled_t:sock_file write;
>>
>> #============= accountsd_t ==============
>>
>> allow accountsd_t unlabeled_t:file { getattr map open read rename
>> setattr unlink write };
>>
>> allow accountsd_t unlabeled_t:sock_file write;
>>
>> #============= alsa_t ==============
>>
>> allow alsa_t unlabeled_t:file { getattr map open read rename unlink
>> write };
>>
>> #============= auditd_t ==============
>>
>> allow auditd_t unlabeled_t:file { getattr map open read };
>>
>> allow auditd_t unlabeled_t:sock_file write;
>>
>> #============= avahi_t ==============
>>
>> allow avahi_t unlabeled_t:file { getattr map open read };
>>
>> allow avahi_t unlabeled_t:sock_file write;
>>
>> #============= chkpwd_t ==============
>>
>> allow chkpwd_t unlabeled_t:file { getattr map open read };
>>
>> allow chkpwd_t unlabeled_t:sock_file write;
>>
>> #============= chronyc_t ==============
>>
>> allow chronyc_t unlabeled_t:file map;
>>
>> #============= chronyd_t ==============
>>
>> allow chronyd_t initrc_var_run_t:file read;
>>
>> allow chronyd_t unlabeled_t:file { getattr map open read rename unlink
>> write };
>>
>> allow chronyd_t unlabeled_t:lnk_file read;
>>
>> allow chronyd_t unlabeled_t:sock_file write;
>>
>> #============= colord_t ==============
>>
>> allow colord_t unlabeled_t:file { getattr map open read };
>>
>> allow colord_t unlabeled_t:sock_file write;
>>
>> #============= cupsd_t ==============
>>
>> allow cupsd_t unlabeled_t:file { getattr map open read rename setattr
>> unlink write };
>>
>> allow cupsd_t unlabeled_t:lnk_file read;
>>
>> allow cupsd_t unlabeled_t:sock_file write;
>>
>> #============= firewalld_t ==============
>>
>> allow firewalld_t unlabeled_t:file { getattr map open read };
>>
>> allow firewalld_t unlabeled_t:sock_file write;
>>
>> #============= fprintd_t ==============
>>
>> allow fprintd_t unlabeled_t:file { getattr map open read };
>>
>> #============= geoclue_t ==============
>>
>> allow geoclue_t unlabeled_t:file { getattr map open read };
>>
>> allow geoclue_t unlabeled_t:lnk_file read;
>>
>> #============= getty_t ==============
>>
>> allow getty_t unlabeled_t:file read;
>>
>> allow getty_t unlabeled_t:sock_file write;
>>
>> #============= gssproxy_t ==============
>>
>> allow gssproxy_t unlabeled_t:file { getattr map open read };
>>
>> allow gssproxy_t unlabeled_t:lnk_file read;
>>
>> allow gssproxy_t unlabeled_t:sock_file unlink;
>>
>> #============= init_t ==============
>>
>> allow init_t unlabeled_t:dir { add_name remove_name rmdir };
>>
>> allow init_t unlabeled_t:file { map rename setattr unlink write };
>>
>> allow init_t unlabeled_t:sock_file write;
>>
>> #============= iptables_t ==============
>>
>> allow iptables_t unlabeled_t:file { getattr map open read };
>>
>> #============= iscsid_t ==============
>>
>> allow iscsid_t unlabeled_t:file { getattr map open read };
>>
>> #============= kernel_t ==============
>>
>> allow kernel_t unconfined_t:process transition;
>>
>> #============= local_login_t ==============
>>
>> allow local_login_t unlabeled_t:file read;
>>
>> allow local_login_t unlabeled_t:sock_file write;
>>
>> #============= logrotate_t ==============
>>
>> allow logrotate_t unlabeled_t:file { open read write };
>>
>> allow logrotate_t unlabeled_t:sock_file write;
>>
>> #============= mandb_t ==============
>>
>> allow mandb_t unlabeled_t:file { open read unlink write };
>>
>> #============= mcelog_t ==============
>>
>> allow mcelog_t unlabeled_t:file { getattr map open read };
>>
>> allow mcelog_t unlabeled_t:sock_file write;
>>
>> #============= modemmanager_t ==============
>>
>> allow modemmanager_t unlabeled_t:file { getattr map open read };
>>
>> #============= named_t ==============
>>
>> allow named_t unlabeled_t:file { open write };
>>
>> #============= nfsd_t ==============
>>
>> allow nfsd_t unlabeled_t:file map;
>>
>> #============= pcscd_t ==============
>>
>> allow pcscd_t unlabeled_t:file { getattr map open read };
>>
>> #============= plymouthd_t ==============
>>
>> allow plymouthd_t unlabeled_t:file { getattr map open read };
>>
>> #============= policykit_auth_t ==============
>>
>> allow policykit_auth_t unlabeled_t:file { getattr map open read };
>>
>> allow policykit_auth_t unlabeled_t:sock_file write;
>>
>> #============= policykit_t ==============
>>
>> allow policykit_t unlabeled_t:file { getattr map open read };
>>
>> allow policykit_t unlabeled_t:sock_file write;
>>
>> #============= rngd_t ==============
>>
>> allow rngd_t unlabeled_t:file { getattr map open read };
>>
>> #============= rpcd_t ==============
>>
>> allow rpcd_t unlabeled_t:file { getattr map open read };
>>
>> #============= rtkit_daemon_t ==============
>>
>> allow rtkit_daemon_t unlabeled_t:file { getattr map open read };
>>
>>
>> allow rtkit_daemon_t unlabeled_t:sock_file write;
>>
>> #============= sssd_t ==============
>>
>> allow sssd_t init_var_run_t:dir read;
>>
>> allow sssd_t unlabeled_t:file { getattr lock map open read setattr
>> unlink write };
>>
>> allow sssd_t unlabeled_t:lnk_file { read unlink };
>>
>> allow sssd_t unlabeled_t:sock_file { getattr setattr unlink write };
>>
>> #============= system_dbusd_t ==============
>>
>> allow system_dbusd_t unlabeled_t:file { getattr map open };
>>
>> #============= systemd_gpt_generator_t ==============
>>
>> allow systemd_gpt_generator_t unlabeled_t:file read;
>>
>> #============= systemd_hostnamed_t ==============
>>
>> allow systemd_hostnamed_t unlabeled_t:file { getattr map open read };
>>
>> #============= systemd_localed_t ==============
>>
>> allow systemd_localed_t unlabeled_t:file { getattr map open read };
>>
>> #============= systemd_logind_t ==============
>>
>> allow systemd_logind_t unlabeled_t:file { getattr map open read };
>>
>> allow systemd_logind_t unlabeled_t:sock_file write;
>>
>> #============= systemd_resolved_t ==============
>>
>> allow systemd_resolved_t unlabeled_t:file { getattr map open read };
>>
>> allow systemd_resolved_t unlabeled_t:lnk_file read;
>>
>>
>> allow systemd_resolved_t unlabeled_t:sock_file write;
>>
>> #============= systemd_tmpfiles_t ==============
>>
>>
>> allow systemd_tmpfiles_t unlabeled_t:file map;
>>
>> #============= systemd_userdbd_t ==============
>>
>>
>> allow systemd_userdbd_t unlabeled_t:file { getattr map open read };
>>
>>
>> allow systemd_userdbd_t unlabeled_t:sock_file write;
>>
>> #============= vdagent_t ==============
>>
>>
>> allow vdagent_t unlabeled_t:file { getattr map open read };
>>
>> #============= virt_qemu_ga_t ==============
>>
>>
>> allow virt_qemu_ga_t power_unit_file_t:service status;
>>
>>
>> allow virt_qemu_ga_t unlabeled_t:file { getattr map open read };
>>
>> #============= xdm_t ==============
>>
>>
>> allow xdm_t unlabeled_t:file { getattr map open read rename unlink
>> write };
>>
>>
>> allow xdm_t unlabeled_t:lnk_file read;
>>
>>
>> allow xdm_t unlabeled_t:sock_file write;
>>
>>
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
>
> The problem is the image has no label associated with it, so that it
> is treated as unlabeled_t.
>
> From the AVCs, I am seeing it looks like /run directory is part of the
> image?  If so you should be mounting a tmpfs on /run and not using
> virtio for this activity.

Thanks for the note.   In this case virtiofs is deployed as the root
file system in the qemu/kvm guest, as contemplated and advertised in the
official virtiofs documents available here: 
https://virtio-fs.gitlab.io/howto-boot.html

So I don't think I was, as the phrase goes, pushing the identified
boundaries of intended use.

For what it's worth, I have implemented dracut modules, patterned after
9p as a root fs, that allow the kernel command line to have the same
syntax as other rootfs file systems.  I've posted those on this mailing
list.  Presently selinux has to either disabled or permissive for
anything close to normal operation on a fedora workstation rev 33.





