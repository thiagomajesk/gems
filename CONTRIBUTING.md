# Contributing 

Thank you for considering contributing to GEMS 💎.  
Before contributing, make sure to review our contribution guidelines.

## Guidelines

### Issues

Bug reports and feature suggestions must use descriptive and concise titles and be submitted via GitHub Issues. Please use the search function to make sure that you are not submitting duplicates, and that a similar report or request has not already been resolved or rejected.

### Pull Requests

Use clear, concise titles for pull requests When creating a pull request, consider that the person reading the title may not be a programmer. Try to describe your change or fix from their perspective. We use commit squashing, so the final commit in the main branch will carry the title of the pull request, and commits from the main branch are fed into the changelog. To ensure easier sorting, start your pull request title with one of the verbs **"Add"**, **"Change"**, **"Deprecate"**, **"Remove"**, or **"Fix"** (present tense).

> While it may not always be possible to phrase every change in this manner, please do so if you can.

### Code changes

- **Features**: Please do not work on major features and ideas without first creating an issue for discussion. The project has a strong direction and we are unlikely to accept new features without prior alignment with the core team.
- **Fixes**: If you are fixing a bug, please open a pull request (PR). Ensure that your changes include passing tests, adhere to our coding style, and that the PR references the issue it resolves.
- **Testing**: New features should also ideally come with additional tests to ensure they work as expected, and don't break existing code. We also welcome test-only pull requests to increase coverage on untested processes and features.  
- **Refactors**: Avoid submitting refactor-only pull requests. Instead, fix a bug or implement a feature while improving the code.