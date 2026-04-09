/**
 * BharatTesting MCP Server
 * 
 * Implements the Model Context Protocol to expose generators as native AI tools.
 */

module.exports = async (req, res) => {
  // MCP Handshake / SSE Setup
  if (req.method === 'GET') {
    res.setHeader('Content-Type', 'application/json');
    return res.status(200).json({
      mcp_version: "1.0",
      capabilities: {
        tools: {
          listChanged: true
        }
      },
      server_info: {
        name: "BharatTesting",
        version: "1.0.0"
      }
    });
  }

  // Handle Tool Execution
  if (req.method === 'POST') {
    const { method, params } = req.body;

    if (method === 'tools/list') {
      return res.status(200).json({
        tools: [
          {
            name: "generate_aadhaar",
            description: "Generate valid Indian Aadhaar numbers with Verhoeff checksum",
            inputSchema: {
              type: "object",
              properties: {
                count: { type: "integer", minimum: 1, maximum: 50 }
              }
            }
          },
          {
            name: "generate_indian_profile",
            description: "Generate complete Indian user profiles (name, address, phone)",
            inputSchema: {
              type: "object",
              properties: {
                count: { type: "integer", minimum: 1, maximum: 10 },
                state: { type: "string" }
              }
            }
          }
        ]
      });
    }

    res.status(404).json({ error: "Method not found" });
  }
};
