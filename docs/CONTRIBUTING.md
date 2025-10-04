# Contributing to Realistic Spell FPS

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
4. Run tests: `cargo test --workspace`
5. Run formatter: `cargo fmt --all`
6. Run linter: `cargo clippy --workspace`
7. Commit with clear messages
8. Push and create a pull request

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
