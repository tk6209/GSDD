# GSDD SPEC — Valid Example

## Scope
Add email + password login to the web application.

## Objective
Allow registered users to authenticate using email and password.

## Inputs
- Email (string)
- Password (string)

## Constraints
- No changes outside the auth module
- No UI redesign
- No new dependencies

## Expected Outcome
- User can log in with valid credentials
- Invalid credentials are rejected
- Existing tests continue to pass
