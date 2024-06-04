# Postmortem
# Background Context
Issue Summary:
Duration: June 1, 2024, 13:05 GMT
Impact: The web server hosting our company's website experienced an outage, rendering the website inaccessible to users. Users were affected, experiencing either slow loading times or complete unavailability.
The service failed 100% of the time which if deployed like that, 100% of users will experience a 500 internal server error.
# Root Cause and Resolution:
Root Cause: The root cause of the issue was identified as a misconfiguration in the server's firewall settings. The firewall was incorrectly configured to block incoming traffic, leading to the rejection of legitimate user requests
 
Resolution: The issue was resolved by promptly reconfiguring the firewall to allow incoming traffic. Additionally, measures were put in place to ensure proper configuration management to prevent similar incidents in the future.
 
# Debugging Process
Two apache2 processes - root and www-data - were properly running.
Looked in the sites-available folder of the /etc/apache2/ directory. Determined that the web server was serving content located in /var/www/html/.
In one terminal, ran strace on the PID of the root Apache process. In another, curled the server. Expected great things... only to be disappointed. strace gave no useful information.
Repeated step 3, except on the PID of the www-data process. Kept expectations lower this time... but was rewarded! strace revealed an -1 ENOENT (No such file or directory) error occurring upon an attempt to access the file /var/www/html/wp-includes/class-wp-locale.phpp.
Looked through files in the /var/www/html/ directory one-by-one, using Vim pattern matching to try and locate the erroneous .phpp file extension. Located it in the wp-settings.php file. (Line 137, require_once( ABSPATH . WPINC . '/class-wp-locale.php' );).
Removed the trailing p from the line.
Tested another curl on the server.
Wrote a Puppet manifest to automate fixing of the error.
 
# Corrective and Preventative Measures:
This outage was not a web server error, but an application error. To prevent such outages moving forward, please keep the following in mind.
Test! Test test test. Test the application before deploying. This error would have arisen and could have been addressed earlier had the app been tested.
Status monitoring. Enable some uptime-monitoring service such as UptimeRobot to alert instantly upon outage of the website.
Regular audits of firewall configurations to ensure alignment with security policies.
Implement automated monitoring for firewall rules to detect and alert on any unexpected changes.
Conduct a comprehensive review of all server firewall configurations to identify and correct any potential misconfigurations.
Develop and implement automated tests to verify the integrity of firewall rules after any configuration changes.

