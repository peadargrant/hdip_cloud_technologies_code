# demo SQS producer script
# Peadar Grant

param (
	[Parameter(Mandatory)] $QUrl
	)

while (1) {

	Write-Host "Message> " -NoNewline -ForegroundColor Green
	$Message = Read-Host
	
	$Response = aws sqs send-message --queue-url $QUrl --message-body $Message

}