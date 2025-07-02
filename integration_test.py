import requests

# Jira connection test
jira_url = "https://mohammedsalghi24.atlassian.net/browse/SCRUM-11"
print(f"Testing connection to Jira issue: {jira_url}")

try:
    response = requests.get(jira_url)
    print(f"Jira Status Code: {response.status_code}")
    if response.status_code == 200:
        print("✅ Successfully connected to Jira!")
    else:
        print(f"⚠️ Could not connect to Jira: {response.status_code}")
except Exception as e:
    print(f"⚠️ Error connecting to Jira: {str(e)}")

# GitHub connection test
github_url = "https://github.com/MohammedSalghi/SC-Grpup-2-DevOps-Project-1"
print(f"\nTesting connection to GitHub repository: {github_url}")

try:
    response = requests.get(github_url)
    print(f"GitHub Status Code: {response.status_code}")
    if response.status_code == 200:
        print("✅ Successfully connected to GitHub repository!")
    else:
        print(f"⚠️ Could not connect to GitHub: {response.status_code}")
except Exception as e:
    print(f"⚠️ Error connecting to GitHub: {str(e)}")

# Test connection to Jenkins
jenkins_url = "http://localhost:8081"
print(f"\nTesting connection to Jenkins: {jenkins_url}")

try:
    response = requests.get(jenkins_url)
    print(f"Jenkins Status Code: {response.status_code}")
    if response.status_code == 200:
        print("✅ Successfully connected to Jenkins!")
    else:
        print(f"⚠️ Could not connect to Jenkins: {response.status_code}")
except Exception as e:
    print(f"⚠️ Error connecting to Jenkins: {str(e)}")

print("\nIntegration testing complete!")
