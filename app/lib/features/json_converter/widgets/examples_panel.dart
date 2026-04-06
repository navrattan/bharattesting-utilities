import 'package:flutter/material.dart';

class ExamplesPanel extends StatelessWidget {
  final ValueChanged<String> onExampleSelected;

  const ExamplesPanel({
    super.key,
    required this.onExampleSelected,
  });

  static final List<Example> _examples = [
    Example(
      title: 'Malformed JSON',
      description: 'JSON with multiple syntax issues',
      format: 'JSON',
      data: '''{
  name: "John Doe",        // Single quotes and comment
  age: 30,
  skills: [
    "JavaScript",
    "Python",
    "Flutter",             // Trailing comma
  ],
  active: True,            // Python boolean
  profile: {
    bio: "Software developer",
    location: null,
  },                       // Trailing comma
}''',
    ),
    Example(
      title: 'CSV Data',
      description: 'Employee data in CSV format',
      format: 'CSV',
      data: '''name,department,salary,active
John Doe,Engineering,75000,true
Jane Smith,Marketing,65000,false
Bob Johnson,Sales,55000,true
Alice Brown,Engineering,82000,true''',
    ),
    Example(
      title: 'YAML Configuration',
      description: 'Application configuration in YAML',
      format: 'YAML',
      data: '''# Application Configuration
app:
  name: BharatTesting Utilities
  version: "1.0.0"
  environment: production

database:
  host: localhost
  port: 5432
  name: bharattesting_db
  ssl: true

features:
  - document_scanner
  - image_reducer
  - pdf_merger
  - json_converter
  - data_faker

cache:
  enabled: true
  timeout: 300
  max_size: 1000''',
    ),
    Example(
      title: 'XML Data',
      description: 'Product catalog in XML format',
      format: 'XML',
      data: '''<?xml version="1.0" encoding="UTF-8"?>
<catalog>
  <product id="1">
    <name>Laptop</name>
    <category>Electronics</category>
    <price currency="USD">899.99</price>
    <in_stock>true</in_stock>
  </product>
  <product id="2">
    <name>Smartphone</name>
    <category>Electronics</category>
    <price currency="USD">599.99</price>
    <in_stock>false</in_stock>
  </product>
</catalog>''',
    ),
    Example(
      title: 'URL-Encoded Data',
      description: 'Form submission data',
      format: 'URL',
      data: '''name=John%20Doe&email=john.doe%40example.com&age=30&skills=JavaScript%2CPython%2CFlutter&subscribe=true&comments=Looking%20forward%20to%20new%20features%21''',
    ),
    Example(
      title: 'INI Configuration',
      description: 'Server configuration file',
      format: 'INI',
      data: '''# Server Configuration
[server]
host=0.0.0.0
port=8080
debug=false
workers=4

[database]
driver=postgresql
host=localhost
port=5432
database=app_db
username=admin
password=secret123

[logging]
level=INFO
file=/var/log/app.log
max_size=100MB
backup_count=5

[cache]
backend=redis
host=localhost
port=6379
timeout=300''',
    ),
    Example(
      title: 'Complex Nested JSON',
      description: 'API response with nested objects',
      format: 'JSON',
      data: '''{
  "users": [
    {
      "id": 1,
      "name": "Alice Johnson",
      "email": "alice@example.com",
      "profile": {
        "avatar": "https://example.com/avatar1.jpg",
        "bio": "Full-stack developer",
        "social": {
          "github": "alice-dev",
          "twitter": "@alice_codes"
        }
      },
      "preferences": {
        "theme": "dark",
        "notifications": true,
        "language": "en"
      },
      "permissions": ["read", "write", "admin"]
    }
  ],
  "pagination": {
    "page": 1,
    "per_page": 10,
    "total": 1,
    "has_more": false
  },
  "meta": {
    "request_id": "req_123456",
    "timestamp": "2024-01-15T10:30:00Z",
    "version": "v1"
  }
}''',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.library_books_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  'Examples',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Examples list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _examples.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final example = _examples[index];
                return _buildExampleCard(context, example, theme);
              },
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Click any example to load it into the editor',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, Example example, ThemeData theme) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onExampleSelected(example.data),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  _buildFormatBadge(context, example.format, theme),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      example.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                example.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 12),

              // Preview
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getPreview(example.data),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatBadge(BuildContext context, String format, ThemeData theme) {
    final formatColors = {
      'JSON': theme.colorScheme.primary,
      'CSV': Colors.green,
      'YAML': Colors.blue,
      'XML': Colors.orange,
      'URL': Colors.purple,
      'INI': Colors.teal,
    };

    final color = formatColors[format] ?? theme.colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        format,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getPreview(String data) {
    final lines = data.split('\n');
    final preview = lines.take(3).join('\n');
    return preview.length > 100 ? '${preview.substring(0, 100)}...' : preview;
  }
}

class Example {
  final String title;
  final String description;
  final String format;
  final String data;

  const Example({
    required this.title,
    required this.description,
    required this.format,
    required this.data,
  });
}