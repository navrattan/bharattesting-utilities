const yaml = require('js-yaml');

/**
 * Shared formatter for BharatTesting API responses
 * Supports: JSON, CSV, XML, SQL, YAML, NDJSON, Playwright Fixtures
 */
module.exports = (req, res, data, rootName = 'results') => {
  const queryFormat = req.query.format;
  const acceptHeader = req.headers.accept || '';
  
  // Determine format: Query param takes precedence, then Accept header
  let format = 'json';
  if (queryFormat) {
    format = queryFormat.toLowerCase();
  } else if (acceptHeader.includes('text/csv')) {
    format = 'csv';
  } else if (acceptHeader.includes('application/xml')) {
    format = 'xml';
  } else if (acceptHeader.includes('text/yaml') || acceptHeader.includes('application/x-yaml')) {
    format = 'yaml';
  } else if (acceptHeader.includes('application/x-ndjson')) {
    format = 'ndjson';
  }

  const results = Array.isArray(data) ? data : [data];

  switch (format) {
    case 'csv':
      res.setHeader('Content-Type', 'text/csv');
      if (results.length === 0) return res.send('');
      const keys = Object.keys(typeof results[0] === 'object' ? results[0] : { value: results[0] });
      const header = keys.join(',') + '\n';
      const rows = results.map(item => {
        const obj = typeof item === 'object' ? item : { value: item };
        return keys.map(k => {
          const val = obj[k];
          return typeof val === 'string' ? `"${val.replace(/"/g, '""')}"` : val;
        }).join(',');
      }).join('\n');
      return res.send(header + rows);

    case 'xml':
      res.setHeader('Content-Type', 'application/xml');
      const xmlRows = results.map(item => {
        if (typeof item !== 'object') return `  <item>${item}</item>`;
        const fields = Object.entries(item).map(([k, v]) => `    <${k}>${v}</${k}>`).join('\n');
        return `  <item>\n${fields}\n  </item>`;
      }).join('\n');
      return res.send(`<?xml version="1.0" encoding="UTF-8"?>\n<${rootName}>\n${xmlRows}\n</${rootName}>`);

    case 'yaml':
      res.setHeader('Content-Type', 'text/yaml');
      return res.send(yaml.dump({ [rootName]: results }));

    case 'ndjson':
      res.setHeader('Content-Type', 'application/x-ndjson');
      return res.send(results.map(r => JSON.stringify(r)).join('\n'));

    case 'sql':
      res.setHeader('Content-Type', 'text/plain');
      if (results.length === 0) return res.send('-- No data');
      const table = rootName;
      const columns = Object.keys(typeof results[0] === 'object' ? results[0] : { value: results[0] });
      const sqlRows = results.map(item => {
        const obj = typeof item === 'object' ? item : { value: item };
        const values = columns.map(k => {
          const val = obj[k];
          return typeof val === 'string' ? `'${val.replace(/'/g, "''")}'` : val;
        }).join(', ');
        return `(${values})`;
      }).join(',\n');
      return res.send(`INSERT INTO ${table} (${columns.join(', ')}) VALUES\n${sqlRows};`);

    case 'playwright':
      res.setHeader('Content-Type', 'application/json');
      return res.json({
        fixtures: results.map((r, i) => ({
          name: `test_data_${i + 1}`,
          data: r
        }))
      });

    case 'json':
    default:
      res.setHeader('Content-Type', 'application/json');
      return res.status(200).json({
        data: results,
        meta: {
          count: results.length,
          format: 'json',
          generated_at: new Date().toISOString()
        }
      });
  }
};
