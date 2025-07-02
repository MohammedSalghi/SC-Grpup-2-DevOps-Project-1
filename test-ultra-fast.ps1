# Ultra Fast Jenkins Test
Write-Host "⚡ Testing Ultra Fast Pipeline..." -ForegroundColor Yellow

# Make a quick commit to test
$commitMessage = "SCRUM-11: Ultra fast pipeline test - $(Get-Date -Format 'HH:mm:ss')"
Write-Host "📝 Creating test commit: $commitMessage" -ForegroundColor Blue

# Add and commit
git add .
git commit -m $commitMessage
git push origin main

Write-Host "✅ Test commit pushed!" -ForegroundColor Green
Write-Host "🚀 Pipeline should start automatically via webhook" -ForegroundColor Cyan
Write-Host "📊 Expected duration: ~5-10 seconds" -ForegroundColor Yellow
Write-Host "🌐 Check Jenkins: http://localhost:8081" -ForegroundColor Cyan
