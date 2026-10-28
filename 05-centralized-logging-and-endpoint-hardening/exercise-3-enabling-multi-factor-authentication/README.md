# Exercise 3 – Enabling Multi-Factor Authentication

[← Back to Lab Overview](../README.md)

---

## Overview

**Multifactor Authentication (MFA)** is essential for protecting user accounts, strengthening access controls, and reducing the risk of unauthorized access within enterprise environments.

Multifactor authentication adds an additional layer of security by requiring users to verify their identity through multiple authentication factors. Common authentication methods include **smart cards, authentication applications, and security keys**, which can provide additional protection beyond traditional password-based authentication.


## Objectives:

- **Active Directory User Management:** Create a new user account in Active Directory to establish an identity for authentication configuration.
- **Multifactor Authentication Configuration:** Enable multifactor authentication for the Active Directory user to strengthen account protection and access security.


## Devices

- **corp-dc-001** – Windows Server – Domain Controller, Active Directory Users and Computers (192.168.20.2)
- **corp-wks-001** – Windows 11 – domain workstation used to test the enforced logon (192.168.30.3)

---

## Task 1 – Create the Active Directory User

1. Log into the **corp-dc-001** domain controller.

   ![Log into the domain controller](screenshots/exercise-3/e3-01-login-domain-controller.png)

2. Open **Server Manager → Tools → Active Directory Users and Computers**.

   ![Open Active Directory Users and Computers](screenshots/exercise-3/e3-02-open-aduc.png)

3. Under **Polarized Systems → Users → Finance**, right-click and choose **New → User**.

   ![New user in the Finance OU](screenshots/exercise-3/e3-03-new-user-finance-ou.png)

4. Set the account's password and options.

   ![Set the user password](screenshots/exercise-3/e3-04-set-user-password.png)

5. Review the new-account summary.

   ![Confirm the new user](screenshots/exercise-3/e3-05-confirm-new-user.png)

6. Finish — the user **Ella Smith** (`ella.smith@corp.polarizedsystems.com`) is created in the Finance OU.

   ![User created](screenshots/exercise-3/e3-06-open-user-properties.png)

---

## Task 2 – Enforce Smart-Card MFA

7. Right-click the new user and open **Properties → Account** tab. Under **Account options**, tick **Smart card is required for interactive logon**, then **Apply**.

   ![Smart card is required for interactive logon](screenshots/exercise-3/e3-07-smart-card-required.png)


8. The account is created and the control is set.

   ![User account in ADUC](screenshots/exercise-3/e3-08-user-created.png)

---

## Task 3 – Verify the Control Is Enforced

9. On **corp-wks-001**, at the logon screen choose **Other user**.

   ![Other user at the logon screen](screenshots/exercise-3/e3-09-login-other-user.png)

10. Attempt a normal **password** logon as `POLARIZED\Ella.Smith`.

    ![Attempt password logon as Ella.Smith](screenshots/exercise-3/e3-10-ella-smith-credentials.png)

11. The logon is refused with **"You must use Windows Hello or a smart card to sign in."** — the MFA requirement is enforced exactly as configured.

    ![MFA enforced – smart card required](screenshots/exercise-3/e3-11-mfa-enforced.png)

---


> This exercise demonstrated how **multifactor authentication (MFA)** strengthens Active Directory security by protecting user accounts against compromised credentials.
>
Key Findings & Security Outcomes:
>
 - **Account Protection:** Enforced smart-card authentication to prevent password-only access.
 - **Credential Security:** Reduced exposure to unauthorized access through stolen passwords.
 - **Privileged Access:** Highlighted the importance of MFA for administrative and high-risk accounts.
 - **Security Monitoring:** Identified opportunities to monitor authentication events through Splunk.
 - **Strengthens identity security, reduces credential-based attack, and improves enterprise access controls.**


---

[← Previous: Exercise 2 – Encrypting Sensitive Data](../exercise-2-encrypting-sensitive-data/README.md) | [Back to Lab Overview](../README.md)
