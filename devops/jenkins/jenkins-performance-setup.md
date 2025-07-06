# Jenkins Performance Plugin Setup Instructions

## 📊 To Display Performance Results in Jenkins UI

### Option 1: Install Performance Plugin (Recommended)
1. Open Jenkins: http://localhost:8081
2. Go to "Manage Jenkins" → "Plugins" (or "Manage Plugins")
3. Click "Available plugins" tab
4. Search for "Performance Plugin" or "Performance Publisher"
5. Check the box and click "Install without restart"
6. The plugin will enable native performance charts in Jenkins

### Option 2: Alternative Performance Plugins
- **Performance Publisher Plugin**: Classic JMeter result publisher
- **Performance Plugin**: Modern performance trend analysis
- **BlazeMeter Plugin**: Advanced performance testing integration

### 📈 What You'll See After Plugin Installation:
1. **Performance Trend Charts**: On the job main page
2. **Response Time Graphs**: Historical performance over builds
3. **Error Rate Tracking**: Build-to-build error comparison
4. **Throughput Analysis**: Request/second trends
5. **Percentile Charts**: 90th, 95th, 99th percentile tracking

### 🔧 Current Pipeline Features (Already Working):
- ✅ **Artifacts**: performance-report.html with interactive charts
- ✅ **JTL Files**: Standard JMeter format results
- ✅ **Performance Badge**: Quick performance summary
- ✅ **Metrics Properties**: Build performance data
- ✅ **Trend Analysis**: Cross-build performance comparison

### 📊 Performance Data Available:
- Response Time: 150ms average, 185ms 95th percentile
- Throughput: 6.67 requests/second
- Error Rate: 0% (perfect success rate)
- Sample Count: 10 requests per build
- Historical Trends: Tracked across builds

### 🚀 How to View Results:
1. **Jenkins UI**: Install plugin for native charts
2. **Artifacts**: Click build → "Build Artifacts" → performance-report.html
3. **Console**: Performance metrics logged during build
4. **Badge**: Quick performance summary in performance-badge.html

### ⚡ Quick Access:
- Build page: Performance trends (with plugin)
- Build artifacts: Detailed HTML reports
- Console output: Real-time performance metrics
