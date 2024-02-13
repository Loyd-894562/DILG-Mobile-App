String getTypeFromPath(String filePath) {
  List<String> parts = filePath.split('/');
  if (parts.length > 1) {
    String folder = parts[parts.length - 2].toLowerCase();

    if (folder.contains('Latest Issuance')) {
      return 'Latest Issuance';
    } else if (folder.contains('Joint Circulars')) {
      return 'Joint Circulars';
    } else if (folder.contains('Memo Circulars')) {
      return 'Memo Circulars';
    } else if (folder.contains('Presidential Directives')) {
      return 'Presidential Directives';
    } else if (folder.contains('Draft Issuances')) {
      return 'Draft Issuances';
    } else if (folder.contains('Republic Acts')) {
      return 'Republic Acts';
    } else if (folder.contains('Legal Opinions')) {
      return 'Legal Opinions';
    }
  }
  // Default category if no matching folder is found
  return 'Other';
}

String getTypeForDownload(String issuanceType) {
  // Map issuance types to corresponding download types
  switch (issuanceType) {
    case 'Latest Issuance':
      return 'Latest Issuance';
    case 'Joint Circulars':
      return 'Joint Circulars';
    case 'Memo Circulars':
      return 'Memo Circulars';
     case 'Presidential Directives':
      return 'Presidential Directives';  
     case 'Draft Issuances':
      return 'Draft Issuances';  
     case 'Republic Acts':
      return 'Republic Acts';  
     case 'Legal Opinions':
      return 'Legal Opinions';  
  
    default:
      return 'Other';
  }
}