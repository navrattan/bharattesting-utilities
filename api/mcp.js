/**
 * BharatTesting MCP (Model Context Protocol) Server
 * Implements SSE transport for AI Agent native tool discovery.
 */

module.exports = async (req, res) => {
  // Set headers for SSE
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();

  // 1. Initial Handshake / Tool Registration
  const tools = [
    {
      name: "generate_aadhaar",
      description: "Generate valid 12-digit Indian Aadhaar numbers with Verhoeff checksum",
      inputSchema: {
        type: "object",
        properties: {
          count: { type: "integer", minimum: 1, maximum: 100, default: 1 }
        }
      }
    },
    {
      name: "generate_pan",
      description: "Generate valid Indian PAN numbers with entity-type awareness",
      inputSchema: {
        type: "object",
        properties: {
          count: { type: "integer", default: 1 },
          type: { 
            type: "string", 
            enum: ["P", "C", "H", "F", "A", "T", "B", "L", "J", "G"],
            description: "P (Individual), C (Company), etc."
          }
        }
      }
    },
    {
      name: "generate_gstin",
      description: "Generate valid 15-digit Indian GSTIN with state-code validation",
      inputSchema: {
        type: "object",
        properties: {
          count: { type: "integer", default: 1 },
          stateCode: { type: "string", description: "2-digit state code (e.g. 27)" }
        }
      }
    },
    {
      name: "generate_indian_profile",
      description: "Generate complete synthetic Indian user profiles",
      inputSchema: {
        type: "object",
        properties: {
          count: { type: "integer", default: 1 },
          state: { type: "string", description: "Target state for regional names" }
        }
      }
    }
  ];

  // Send tools registration event
  res.write(`event: tools\ndata: ${JSON.stringify(tools)}\n\n`);

  // Keep connection open or close depending on MCP client expectation
  // For Vercel Serverless, we usually handle requests and close, 
  // but MCP SSE expects a persistent stream or a clean close after sync.
  res.end();
};
