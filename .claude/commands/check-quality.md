Run the full quality gate check from RULES.md:

1. Run `flutter analyze` in app/ — report any issues
2. Run `dart format --set-exit-if-changed .` in app/ and core/ — report any formatting violations
3. Run `dart test` in core/ — report any failures
4. Run `flutter test` in app/ — report any failures
5. Check for any TODO comments in code: `grep -rn "TODO" core/lib/ app/lib/ --include="*.dart"`
6. Check that BTQA footer widget is used in all screen files: `grep -rn "BtqaFooter\|btqa_footer" app/lib/features/`

Report a summary: PASS or FAIL with details for each check.
