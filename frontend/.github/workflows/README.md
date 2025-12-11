# GitHub Actions Workflows

## Available Workflows

### flutter-ci.yml
Builds Android and Web on every push to main/develop

### flutter-test.yml
Runs tests and linting

## Usage

- **Automatic**: Pushes to main/develop trigger builds
- **Manual**: Actions tab → Select workflow → Run workflow
- **Release**: Push a version tag (e.g., `git tag v1.0.0 && git push --tags`)

## Download Builds

1. Go to Actions tab
2. Click on a completed workflow run
3. Scroll to Artifacts section
4. Download the builds you need
