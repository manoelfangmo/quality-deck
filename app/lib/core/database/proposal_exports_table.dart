abstract final class ProposalExportsTable {
  static const name = 'proposal_exports';
  static const id = 'id';
  static const businessId = 'business_id';
  static const projectId = 'project_id';
  static const version = 'version';
  static const proposalNumber = 'proposal_number';
  static const storagePath = 'storage_path';
  static const totalCents = 'total_cents';
  static const pageCount = 'page_count';
  static const createdBy = 'created_by';
  static const createdAt = 'created_at';
}

abstract final class EdgeFunctions {
  static const exportProposal = 'export-proposal';
}
