Scruffy's Pizza operates nationwide with 20 stores.
Scruffy's primarily operates as a take-out and delivery pizza service, although it has some in-store restaurants in motorway plazas and some small supermarkets.

-   The IT team comprises 3 individuals at head office: Alice, Bob, John
    and Mary. Under Alice, they are to jointly admin the AWS account.

-   Scruffys wishes install a flat screen advertising display in each
    branch driven by a small computer behind each. Each display will
    show PDFs from a folder onscreen. Menu board images are looked after
    by a marketing team of Sheila and Ann, led by Paddy. The same set of
    images will be displayed in each branch. Each week's menu is also
    available online by a link to the PDF from the website. Scruffy's
    wish to use AWS to update the menu boards nightly with the new
    PDF files.

-   Scruffy's order system is based around a FreeBSD UNIX server in
    each store. This downloads nightly menu price updates from an FTP
    server and uploads transaction log and other data every night to the
    same FTP server. The central office system connects to the FTP
    server during the day and copies the files over locally before
    deleting them. Scruffy's wish to get rid of the FTP server and use
    AWS for file transfer. (AWS CLI and crond scheduler is available
    for FreeBSD)

1.  Diagram out the architecture for the overall system described above.
    You should do this on paper. If you want to make computerised
    diagrams, consider using the AWS architecture icons:
    <https://aws.amazon.com/architecture/icons/> available for various
    diagramming packages.

2.  Design the IAM setup for this on paper to show users, groups
    and policies. While the JSON / ARNs need not be shown, your diagrams
    must make the policy clear.

3.  Set up your proposed solution on AWS. Consider using the profile
    feature on the AWS CLI to try logging in as different people.
