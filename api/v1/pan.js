const formatResponse = require('./utils/formatter');

module.exports = async (req, res) => {
  const { count = 1, type = 'P' } = req.query;
  const numCount = Math.min(parseInt(count), 100);
  
  // PDF P.9: 4th char must match entity type
  const entityTypes = ['P', 'C', 'H', 'F', 'A', 'T', 'B', 'L', 'J', 'G'];
  const selectedType = entityTypes.includes(type.toUpperCase()) ? type.toUpperCase() : 'P';
  
  const entityLabels = {
    'P': 'Individual',
    'C': 'Company',
    'H': 'HUF',
    'F': 'Firm',
    'A': 'AOP',
    'T': 'Trust',
    'B': 'BOI',
    'L': 'Local Authority',
    'J': 'Artificial Juridical Person',
    'G': 'Government'
  };

  const generatePAN = () => {
    let pan = '';
    // First 3 chars: Alpha
    for (let i = 0; i < 3; i++) {
      pan += String.fromCharCode(65 + Math.floor(Math.random() * 26));
    }
    // 4th char: Entity Type
    pan += selectedType;
    // 5th char: Surname/Entity name first char
    pan += String.fromCharCode(65 + Math.floor(Math.random() * 26));
    // 6th to 9th: 4 digits
    for (let i = 0; i < 4; i++) {
      pan += Math.floor(Math.random() * 10).toString();
    }
    // 10th char: Last alpha check digit (simplified for test data)
    pan += String.fromCharCode(65 + Math.floor(Math.random() * 26));
    
    return {
      pan,
      entity_type: selectedType,
      entity_label: entityLabels[selectedType]
    };
  };

  const results = [];
  for (let i = 0; i < numCount; i++) {
    results.push(generatePAN());
  }

  return formatResponse(req, res, results, 'pan_records');
};
