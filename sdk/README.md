# @bharattesting/sdk

Official SDK for BharatTesting Utilities. Generate, validate, and transform India-specific test data with a few lines of code.

## Installation

```bash
npm install @bharattesting/sdk
```

## Quick Start

```javascript
const BharatTesting = require('@bharattesting/sdk');
const bt = new BharatTesting();

// Generate Aadhaar Numbers
const aadhaarRecords = await bt.generateAadhaar(10);
console.log(aadhaarRecords);
```

## Playwright Integration (PDF P.15)

Easily seed your end-to-end tests with valid Indian data.

```typescript
// playwright.config.ts — seed data setup
import { BharatTesting } from '@bharattesting/sdk';
const bt = new BharatTesting();

test('registration flow', async ({ page }) => {
  const users = await bt.generateProfile(1, 'Karnataka');
  const user = users[0];

  await page.goto('https://example.com/register');
  await page.fill('#name', user.name.full);
  await page.fill('#aadhaar', user.aadhaar);
  await page.fill('#phone', user.phone);
  await page.click('#submit');
  
  await expect(page).toHaveURL(/dashboard/);
});
```

## Features

- **P0 Documents**: Aadhaar (Verhoeff), PAN (Entity-aware), GSTIN (State-aware)
- **Financial**: UPI ID, IFSC Code, Bank Accounts
- **Contact**: Phone Numbers, Emails, Addresses
- **Full Profiles**: Complete regional-aware Indian user profiles

## License

MIT - Made in Bengaluru for Bharat.
