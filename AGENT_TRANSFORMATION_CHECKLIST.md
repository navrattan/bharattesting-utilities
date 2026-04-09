# AI Agent Readiness & Transformation Checklist

## 1. Core Architecture (REST API Layer)
- [x] Configure `api.bharattesting.com` subdomain in `vercel.json`
- [x] Implement `/v1` versioned path structure (Consolidated router to bypass Hobby limit)
- [x] Support `Accept` headers for multiple formats (JSON, CSV, XML, SQL, YAML, NDJSON)
- [x] Implement permissive CORS for AI tool compatibility
- [x] Add JSON Schema validation for every response at `/v1/schemas/{generator}.json`

## 2. API Catalog Implementation
### Identity Documents (P0)
- [x] Aadhaar (Verhoeff checksum)
- [x] PAN (Entity-aware: Individual, Company, etc.)
- [x] GSTIN (State-aware + checksum)
- [x] Voter ID (EPIC with state prefixes)
- [x] Driving License (RTO-mapped)
- [x] Passport (Old/New format toggle)

### Financial Data (P0)
- [x] UPI ID (Provider-aware: @okaxis, @paytm, etc.)
- [x] IFSC Code (Bank-to-branch mapping)
- [x] Bank Account Numbers (Bank-specific lengths)
- [x] Credit/Debit Cards (RuPay/Visa/MC with Luhn checksum)
- [x] MICR Code

### Geography & Contacts (P1)
- [x] Indian Address (State/City/Pincode consistent)
- [x] Pin Code (Actual post office mapping)
- [x] Phone Number (+91 format with operator prefixes)
- [x] Indian Names (Region-aware & Multi-script: Latin, Devanagari, Tamil)
- [x] Email (Indian-style: firstname.lastname@)
- [x] Vehicle Registration (State RTO codes)

## 3. AI Discoverability & SEO
- [x] Implement `llms.txt` at root and `/app/web/`
- [x] Publish OpenAPI 3.1 spec at `/v1/openapi.json`
- [x] Add Schema.org (`WebApplication`, `WebAPI`) JSON-LD to `index.html`
- [x] Create server-rendered landing pages for each tool (SSG via custom python script)

## 4. MCP (Model Context Protocol)
- [x] Implement MCP Server over SSE (Server-Sent Events) at `/api/mcp`
- [x] Register all generators as MCP tools with typed input schemas
- [x] Host MCP server at `https://api.bharattesting.com/mcp`

## 5. Developer Experience
- [x] Interactive API Playground (Swagger UI) at `/api/docs`
- [x] Copy-paste cURL examples on tool landing pages
- [x] GitHub README update with Agent usage instructions
- [x] Scaffolding for `@bharattesting/sdk` (NPM module created)
