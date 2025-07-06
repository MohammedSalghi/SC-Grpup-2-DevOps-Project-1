# Jenkins Artifacts Guide

## Why Artifacts Might Not Be Visible

If Jenkins artifacts are not visible in the Jenkins UI after a successful build, here are several possible causes and solutions:

### 1. Artifact Archiving Configuration

Make sure your Jenkinsfile correctly archives artifacts. The correct syntax is:

```groovy
archiveArtifacts artifacts: 'file-pattern', fingerprint: true
```

Key points:
- Use `fingerprint: true` for better tracking
- Specify the correct file path
- Ensure files exist before archiving

### 2. Jenkins UI Navigation

Artifacts are sometimes hidden in the Jenkins UI. To access them:

1. Go to your Jenkins job (http://localhost:8081/job/SC-devops-pipeline/)
2. Click on the specific build number (e.g., #29)
3. Look for "Build Artifacts" in the left sidebar menu
4. If not immediately visible, click on the small triangle next to the build to expand options

### 3. Direct URL Access

Try accessing artifacts directly via URL:
```
http://localhost:8081/job/SC-devops-pipeline/29/artifact/
```

Replace `29` with your build number.

### 4. Jenkins Configuration Issues

Check these Jenkins settings:

- **Plugin Issues**: Ensure the "Archive Artifacts" plugin is installed and enabled
- **Permissions**: Verify Jenkins has read/write permissions to the workspace
- **Storage**: Check if Jenkins is configured to store artifacts
- **Retention Policy**: Ensure "Discard Old Builds" isn't removing your artifacts

### 5. Storage Location

By default, Jenkins stores artifacts in:
```
JENKINS_HOME/jobs/SC-devops-pipeline/builds/29/archive/
```

Check if files exist in this location on the Jenkins server.

## Best Practices for Artifact Visibility

1. **Use Fingerprinting**: Always set `fingerprint: true` when archiving
2. **Create Index Files**: Archive a HTML index file that links to all artifacts
3. **Use Post Block**: Archive in the `post { success { } }` block to ensure it happens after success
4. **Specify Non-Empty**: Use `allowEmptyArchive: false` to fail if no artifacts are found
5. **Improve Pattern Matching**: Use more specific patterns like `**/artifact-*.html`

## Testing Artifact Visibility

Run this PowerShell script to diagnose artifact issues:
```powershell
.\jenkins-artifact-diagnostic.ps1
```

## Using the Jenkins Script Console

If you have admin access to Jenkins, you can run this script in the Jenkins Script Console:

1. Go to: http://localhost:8081/script
2. Run:
```groovy
def job = Jenkins.instance.getItemByFullName("SC-devops-pipeline")
def build = job.getBuildByNumber(29)
println "Build has artifacts: ${!build.artifacts.empty}"
build.artifacts.each { artifact ->
    println "${artifact.fileName}: ${artifact.length} bytes"
}
```

## Post-Build Checks

After your next build completes:

1. Check the console output for any errors during archiving
2. Verify that the `artifact-index.html` file appears in artifacts
3. Access the performance dashboard through the artifact links
4. Confirm all expected files are present and accessible

If issues persist, consider checking the Jenkins logs for more detailed error messages.
