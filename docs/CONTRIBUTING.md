# Contributing to URMOM (Ultimate Realms: Masters of Magic)

Thank you for your interest in contributing!

## Code of Conduct

Please be respectful and constructive in all interactions.

## How to Contribute

### Reporting Bugs

- Use GitHub Issues
- Include reproduction steps
- Provide system information

### Suggesting Features

- Open a GitHub Issue with the "enhancement" label
- Describe the feature and use case
- Consider implementation complexity

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes
4. Run local CI checks (see checklist below)
5. Commit with clear messages
6. Push and create a pull request

#### Pre-Commit Checklist

Before committing, ensure:

- [ ] Code is formatted: `cargo fmt --all`
- [ ] No clippy warnings: `cargo clippy --workspace`
- [ ] All tests pass: `cargo test --workspace`
- [ ] Build succeeds: `cargo build --workspace`
- [ ] Documentation updated (if applicable)

You can run all checks with the local CI scripts:
```bash
./build/ci/lint.sh    # Format and lint checks
./build/ci/test.sh    # Run all tests
./build/ci/build.sh   # Build all crates
```

## Development Guidelines

### Code Style

- Follow Rust conventions
- Use `rustfmt` for formatting
- Address `clippy` warnings
- Write documentation comments for public APIs

### Testing

- Write unit tests for new functionality
- Add integration tests for cross-crate features
- Ensure all tests pass before submitting PR

### Documentation

- Update docs for API changes
- Add examples for new features
- Keep architecture docs current

## Project Areas

We welcome contributions in:

- **Client**: Rendering, input, UI improvements
- **Server**: Network optimization, gameplay logic
- **Engine**: Core systems, performance
- **Editor**: Tools and workflows
- **Assets**: Models, textures, sounds
- **Documentation**: Guides, tutorials, examples

## Questions?

Open a discussion in GitHub Discussions or reach out to maintainers.

## Troubleshooting

### Build Failures

If builds fail in CI but work locally:
- Ensure Cargo.lock is committed (it should be tracked for workspace projects)
- Verify platform-specific dependencies are handled correctly
- Check for missing system libraries on CI platform

### Docker Build Issues

- Ensure Dockerfile paths are correct
- Check base image compatibility
- Verify multi-stage build layers
- If Cargo.lock is missing, Docker builds will generate it automatically

### Test Failures

- Run tests locally first to reproduce
- Check for timing issues in async tests
- Verify test isolation (tests should not depend on execution order)
- Use `RUST_LOG=debug cargo test` for detailed output
