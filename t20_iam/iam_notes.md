Identity and Access Management
==============================

You should refer to the following resources in additon to the
explanations in these notes:

-   <https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html>

-   <https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html>

Root credentials
----------------

Like most other IT services, use of AWS requires a login. The form that
this takes depends on what method the user accesses the service by:

AWS console

:   is accessed by providing e-mail (tied to AWS account) and password.

AWS CLI/SDK

:   is accessed using two similar credentials:

    AWS Access Key ID

    :   which functions like a username.

    Secret key

    :   which functions like a password, and must be kept secret. As
        this is normally not typed often nor from memory, it is longer
        than most normal passwords.

    Unlike the e-mail and password, an AWS account can have 2 access
    keys (active or inactive) at any one time.

Once satisfactory credentials are provided, we can use any AWS services
we want. This is termed our *root credentials*, and is the equivalent of
the `root` account on UNIX-like OSes and the local `Administrator` on
Windows OS.

### Root usage vulnerability

The standard root credentials are easy to use starting off. However,
having a single set of credentials for all-or-nothing access to all
provisioned resources can lead to problems. Consider some of the
following scenarios:

1.  A company provisions an AWS account to host a number of different
    services on. Multiple employees need to be able to use and
    administer different AWS resources relevant only to their
    work function.

2.  A distributed system is built where certain parts of the system need
    differing levels of access (think least privilage!)

3.  A contractor or consultant is employed to help with setting up
    certain AWS resources. We don’t want them to access all of our
    production data, only test data.

4.  Some “users” will not be people at all, but resources within and
    outside AWS that we need to access AWS resources within our account.

5.  We wish to log actions done and associate them to individual users.

We need a way to allow more restricted access to specific resources
within an AWS account, essentially an account-within-an-account
scenario.

IAM Users and groups
--------------------

User:

:   each IAM user can be configured for:

    AWS console access

    :   using a username/password.

    AWS CLI/SDK access

    :   using a set of keys, similar to the root account.

Groups:

:   each IAM user can be a member of any number of IAM groups.

![IAM users in groups<span
data-label="fig:iam-users-groups"></span>](iam_users_groups){width="0.5\linewidth"}

Policies
--------

By default, an IAM user has no permissions to do anything with the AWS
account. Policies are used to grant specific permissions. Policies are
distinct objects that are normally expressed/shown in JSON form. A
policy consists of a number of statements, .

![IAM policy elements<span
data-label="fig:iam-policy-elements"></span>](iam_policy_elements){width="0.7\linewidth"}

### Policy elements

Each policy consists of 1 or more statements that each contain the
following elements:

Sid:

:   each statement is identified by its Sid.

Effect:

:   is to either allow or deny

Principal:

:   is the user (not group!) to which this policy applies.

Action:

:   is a list of the actions to control. Allowed actions are listed for
    each AWS service.

Resource:

:   is the list of resources to apply this policy to, in ARN format.

Condition:

:   can limit the applicability of the policy (see later!)

### Resource and identity-based policies

Resource-based policies

:   are attached to resources (rather than users/groups) and state what
    actions a principal is allow to perform on the resource.

Identity-based policies

:   are attached to a user or group and state what actions the
    user/group can perform on what resources and subject to a number
    of conditions.

### Managed vs inline policies

Identity-based policies can be either managed or inline:

Managed policies

:   

    AWS managed policies

    :   created and controlled by AWS for many common scenarios.

    Customer-managed policies

    :   created and controlled by the AWS account holder. More
        precise control. Written in JSON or with the help of the
        policy editor.

Inline policies

:   are embedded directly with a user/group. Not recommended for
    identity-based policies.

Note that all resource-based policies are inline! There are no managed
resource-based policies.

### Policy evaluation

So far, we can see that multiple different policies may be defined
relating to a resource or principal. shows the evaluation flow used by
AWS. Note that when more complex IAM features are used, this causes
further steps to appear in the process.

![Simplified AWS policy evaluation flow (adapted from AWS documentation,
some category steps omitted)<span
data-label="fig:iam-policy-evaluation-flow_simplified"></span>](iam_policy_evaluation_flow_simplified){width="1.0\linewidth"}

