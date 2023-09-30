#!/usr/bin/env python3
# Billing alarm check script for Cloud modules
# Peadar Grant

import sys
from boto3 import client

cloudwatch = client('cloudwatch')

metric_alarms = cloudwatch.describe_alarms()['MetricAlarms']

target_alarm_name = 'BILLING_ALARM'
missing_alarm = True
recommended_threshold = 10.0
threshold_tolerence = 1.0
billing_alarm = None

for alarm in metric_alarms:
    print('alarm %s' % alarm['AlarmName'])

    if alarm['AlarmName'] == target_alarm_name:
        print('found billing alarm!')
        billing_alarm = alarm
        break

# exit if no billing alarm is found
if billing_alarm is None:
    sys.exit('no alarm named %s !' % target_alarm_name)

# check threshold
print('threshold = %s' % billing_alarm['Threshold'])
if abs(billing_alarm['Threshold'] - recommended_threshold) >= threshold_tolerence:
    print('check threshold [recommended=%s, yours=%s]!' % (recommended_threshold, billing_alarm['Threshold']))
        
# confirm all is OK
print('Your billing alarm is set up correctly')

