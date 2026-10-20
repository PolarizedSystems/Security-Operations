# Exercise 2 – Analyze Account & Group Management

[← Back to Lab Overview](../README.md)

---

## Overview

Privilege escalation is one of the most dangerous moves an attacker makes: quietly adding a compromised or newly created account to a powerful group like **Domain Admins** hands them the keys to the entire domain. This exercise makes that attack visible. I enabled Security Group Management auditing with Group Policy, simulated the attack by creating a user and escalating it straight to Domain Admins, and then detected and attributed the change in the Windows Security log.

> **The detection chain:** *Audit policy records group changes → the attack adds a user to Domain Admins → Event IDs 4728 and 4737 expose who did it, to whom, and when.*

## Devices

- **corp-dc-001** – Windows Server – Domain Controller – Group Policy, Active Directory, Event Viewer (192.168.20.2)

---

## Task 1 – Enable Security Group Management Auditing

1. Log in to **corp-dc-001** as `POLARIZED\Administrator`.

   ![Log in to corp-dc-001](screenshots/exercise-2/e2-01-login-corp-dc-001.png)

2. Open **Server Manager → Tools → Group Policy Management**.

   ![Open Group Policy Management](screenshots/exercise-2/e2-02-open-group-policy-management.png)

3. The console opens on the forest **corp.polarizedsystems.com**, showing the domain and its OUs.

   ![Group Policy Management console](screenshots/exercise-2/e2-03-gpm-console.png)

4. Select **Default Domain Policy**. A notice explains that changes here are global to the GPO — click **OK**.

   ![GPO link warning](screenshots/exercise-2/e2-04-gpo-link-warning.png)

5. Right-click **Default Domain Policy** and select **Edit**.

   ![Edit Default Domain Policy](screenshots/exercise-2/e2-05-edit-default-domain-policy.png)

6. In the Group Policy Management Editor, navigate to **Computer Configuration → Policies → Windows Settings → Security Settings → Advanced Audit Policy Configuration → Audit Policies**.

   ![Navigate to Security Settings](screenshots/exercise-2/e2-06-navigate-security-settings.png)

7. Select **Account Management**, then **Audit Security Group Management** (currently Not Configured).

   ![Account Management audit policies](screenshots/exercise-2/e2-07-audit-account-management.png)

8. Open its properties, tick **Configure the following audit events**, check both **Success** and **Failure**, then click **OK**.

   ![Audit Security Group Management](screenshots/exercise-2/e2-08-audit-success-failure.png)

> ### 🔎 Why the Advanced Audit Policy
> The **Advanced** Audit Policy Configuration gives granular, subcategory-level control instead of the blunt, legacy "Audit account management" switch. Enabling **Security Group Management** specifically tells the Domain Controller to log every change to a security group's membership — additions, removals and modifications — which is exactly the activity a privilege-escalation attack generates. Auditing both **Success** and **Failure** captures changes that went through *and* attempts that were blocked.

9. The subcategory now shows **Success and Failure**.

   ![Audit configured](screenshots/exercise-2/e2-09-audit-configured.png)

10. Close the Group Policy Management Editor.

    ![Close the editor](screenshots/exercise-2/e2-10-close-gpme.png)

11. Open **Windows PowerShell**.

    ![Open PowerShell](screenshots/exercise-2/e2-11-open-powershell.png)

12. Apply the policy immediately:

    ```powershell
    gpupdate /force
    ```

    ![gpupdate /force](screenshots/exercise-2/e2-12-gpupdate.png)

13. Both Computer and User policy updates complete successfully.

    > **Order matters:** auditing is not retroactive — it only records what happens *after* the policy is applied. The audit policy must be enabled and refreshed **before** the attack is simulated, or no event is generated.

    ![gpupdate complete](screenshots/exercise-2/e2-13-gpupdate-complete.png)

---

## Task 2 – Simulate the Attack: Escalate a User to Domain Admins

14. Open **Server Manager → Tools → Active Directory Users and Computers**.

    ![Open ADUC](screenshots/exercise-2/e2-14-open-aduc.png)

15. Expand **Polarized Systems → Users** and right-click the **IT** OU.

    ![ADUC IT OU](screenshots/exercise-2/e2-15-aduc-it-ou.png)

16. Choose **New → User**.

    ![New user](screenshots/exercise-2/e2-16-new-user.png)

17. Create the test user **Jordan Reed** with the logon name `jordan.reed@corp.polarizedsystems.com`, then click **Next**.

    ![New user details](screenshots/exercise-2/e2-17-new-user-details.png)

18. Set a password and click **Next**.

    ![Set password](screenshots/exercise-2/e2-18-set-password.png)

19. Review the summary and click **Finish**.

    ![Finish user creation](screenshots/exercise-2/e2-19-finish-user.png)

20. The user now appears in the IT OU. Right-click **Jordan Reed** and select **Properties**.

    ![User properties](screenshots/exercise-2/e2-20-user-properties.png)

21. Open the **Member Of** tab.

    ![Member Of tab](screenshots/exercise-2/e2-21-member-of-tab.png)

22. The account starts with only **Domain Users** — the expected membership for a standard employee. Click **Add**.

    ![Member Of – Add](screenshots/exercise-2/e2-22-member-of-add.png)

23. Enter **Domain Admins** and click **OK**.

    ![Select Domain Admins](screenshots/exercise-2/e2-23-select-domain-admins.png)

24. The account is now a member of **Domain Admins** — a brand-new standard user with full control of the domain. Click **OK** to apply.

    > **The attack in one line:** a day-old help-desk account shouldn't be a Domain Admin. This is the single most important privilege-escalation pattern to detect in Active Directory.

    ![Added to Domain Admins](screenshots/exercise-2/e2-24-added-to-domain-admins.png)

25. The escalated user is visible in the IT OU alongside the other accounts.

    ![User in ADUC](screenshots/exercise-2/e2-25-user-in-aduc.png)

---

## Task 3 – Detect the Attack in the Event Log

26. Open **Event Viewer**.

    ![Open Event Viewer](screenshots/exercise-2/e2-26-open-event-viewer.png)

27. Go to **Windows Logs → Security**. Enabling the audit policy itself generated **Event ID 4719 – System audit policy was changed**, confirming the control is active.

    ![Event Viewer Security log](screenshots/exercise-2/e2-27-event-viewer-security.png)

28. Use **Filter Current Log** to narrow the log to **Event ID 4728**.

    ![Filter for 4728](screenshots/exercise-2/e2-28-filter-4728.png)

29. The newest **4728 – A member was added to a security-enabled global group** is stamped at the moment of the attack, with the **Subject** showing **POLARIZED\Administrator** as the account that made the change.

    ![Event 4728](screenshots/exercise-2/e2-29-event-4728.png)

30. Open the **Details** tab to see the raw event data.

    ![Event 4728 Details tab](screenshots/exercise-2/e2-30-event-4728-details-tab.png)

31. The Friendly View confirms the full picture: **MemberName** `CN=Jordan Reed,OU=IT,...`, **TargetUserName** `Domain Admins`, and **SubjectUserName** `Administrator`, all logged on **CORP-DC-001**.

    > **The finding:** *Jordan Reed was added to Domain Admins by Administrator.* Member, group, actor and host — everything an investigation needs to decide whether this was authorized, all in one event.

    ![Event 4728 details](screenshots/exercise-2/e2-31-event-4728-details.png)

32. Filter the log for the companion event, **Event ID 4737**.

    ![Filter for 4737](screenshots/exercise-2/e2-32-filter-4737.png)

33. The newest **4737 – A security-enabled global group was changed** is recorded at the same moment.

    ![Event 4737](screenshots/exercise-2/e2-33-event-4737.png)

34. The General tab shows the **Domain Admins** group was changed, attributed to **Administrator**.

    ![Event 4737 general](screenshots/exercise-2/e2-34-event-4737-general.png)

35. The **Details** confirm **TargetUserName** `Domain Admins` and **SubjectUserName** `Administrator`.

    ![Event 4737 details](screenshots/exercise-2/e2-35-event-4737-details.png)

> ### 🔎 4728 vs. 4737 — reading them together
> | Event ID | Meaning | What it tells you |
> |----------|---------|-------------------|
> | **4728** | A member was added to a security-enabled **global** group | *Who* was added, *which* group, and *who* did it |
> | **4737** | A security-enabled **global** group was changed | The group's membership was modified (the companion to 4728) |
>
> The two fire together on a group-membership change. Correlating them pins down the full story — the member, the group and the actor. In production, adding an account to **Domain Admins** is exactly the kind of event that should trigger a real-time SIEM alert, because a legitimate change to that group is rare and an illegitimate one is catastrophic.

---

> ### 🎤 Stakeholder Takeaway
>
> "We made sure that if anyone is given the keys to the kingdom, we'll know about it. First we turned on auditing for changes to our most powerful security groups. Then we tested it the honest way — we created a new account and gave it full domain-admin rights, exactly as an attacker would — and the system recorded precisely what happened: *this user was added to Domain Admins, by this account, at this time.* The lesson for the business is that unusual privilege changes are now visible and attributable, so a quiet escalation can't happen without leaving a trail we can act on."

---

[← Previous: Exercise 1 – Analyze Resource Utilization](../exercise-1-analyze-resource-utilization/README.md) | [Back to Lab Overview](../README.md)
