# AI Agent Readiness & Transformation Checklist

## 1. Core Architecture (REST API Layer)
- [x] Configure `api.bharattesting.com` subdomain in `vercel.json`
- [x] Implement `/v1` versioned path structure
- [ ] Support `Accept` headers for multiple formats (JSON, CSV, XML, SQL, YAML)
- [ ] Implement permissive CORS for AI tool compatibility
- [ ] Add JSON Schema validation for every response at `/v1/schemas/{generator}.json`

## 2. API Catalog Implementation
### Identity Documents (P0)
- [x] Aadhaar (Verhoeff checksum)
- [x] PAN (Entity-aware: Individual, Company, etc.)
- [x] GSTIN (State-aware + checksum)
- [x] Voter ID (EPIC)
- [x] Driving License
- [ ] Passport (New/Old format toggle)

### Financial Data (P0)
- [ ] UPI ID (Provider-aware: @okaxis, @paytm, etc.)
- [ ] IFSC Code (Bank-to-branch mapping)
- [ ] Bank Account Numbers (Bank-specific lengths)
- [ ] MICR Code
- [ ] GST Invoice Generator

### Geography & Contacts (P1)
- [ ] Indian Address (State/City/Pincode consistent)
- [ ] Pin Code (Actual post office mapping)
- [ ] Phone Number (+91 format with operator prefixes)
- [ ] Indian Names (Region-aware: North, South, etc.)
- [ ] Email (Indian-style: firstname.lastname@)
- [ ] Vehicle Registration (State RTO codes)

## 3. AI Discoverability & SEO
- [x] Implement `llms.txt` at root and `/app/web/`
- [x] Publish OpenAPI 3.0 spec at `/v1/openapi.json`
- [ ] Add Schema.org (`WebApplication`, `WebAPI`) JSON-LD to `index.html`
- [ ] Create server-rendered landing pages for each tool (SSR/Static)

## 4. MCP (Model Context Protocol)
- [ ] Implement MCP Server over SSE (Server-Sent Events)
- [ ] Register all generators as MCP tools with typed input schemas
- [ ] Host MCP server at `https://api.bharattesting.com/mcp`

## 5. Developer Experience
- [ ] Interactive API Playground (Swagger UI) at `/api/docs`
- [ ] Copy-paste cURL/Python/JS snippets on tool pages
- [ ] GitHub README update with Agent usage instructions
- [ ] Scaffolding for `@bharattesting/sdk` (NPM/PyPI)
