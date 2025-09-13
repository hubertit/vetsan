import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/collection.dart';
import '../providers/collections_provider.dart';

class PendingCollectionsScreen extends ConsumerStatefulWidget {
  const PendingCollectionsScreen({super.key});

  @override
  ConsumerState<PendingCollectionsScreen> createState() => _PendingCollectionsScreenState();
}

class _PendingCollectionsScreenState extends ConsumerState<PendingCollectionsScreen> {
  final List<String> _rejectionReasons = [
    'Poor Quality',
    'Wrong Quantity',
    'Late Delivery',
    'Contamination',
    'Temperature Issues',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCollections = ref.watch(pendingCollectionsProvider);
    final collectionsNotifier = ref.watch(collectionsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Pending Collections'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimaryColor),
        titleTextStyle: AppTheme.titleMedium.copyWith(color: AppTheme.textPrimaryColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              collectionsNotifier.refreshCollections();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: pendingCollections.isEmpty
          ? _buildEmptyState()
          : _buildCollectionsList(pendingCollections, collectionsNotifier),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pending_actions,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'No Pending Collections',
            style: AppTheme.titleMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'All collections have been reviewed',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsList(List<Collection> collections, CollectionsNotifier notifier) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];
        return _buildCollectionCard(collection, notifier);
      },
    );
  }

  Widget _buildCollectionCard(Collection collection, CollectionsNotifier notifier) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius12),
        border: Border.all(
          color: AppTheme.borderColor,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with supplier info and status
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    collection.supplierName.isNotEmpty 
                        ? collection.supplierName[0].toUpperCase()
                        : 'S',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        collection.supplierName,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        collection.supplierPhone,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing8,
                    vertical: AppTheme.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  ),
                  child: Text(
                    'PENDING',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),
            
            // Collection details
            _buildDetailRow('Quantity', '${NumberFormat('#,##0.0').format(collection.quantity)} L'),
            _buildDetailRow('Price/Liter', 'RWF ${NumberFormat('#,##0.00').format(collection.pricePerLiter)}'),
            _buildDetailRow('Total Value', 'RWF ${NumberFormat('#,##0.00').format(collection.totalValue)}'),
            _buildDetailRow('Collection Date', _formatDate(collection.collectionDate)),
            
            if (collection.notes != null && collection.notes!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacing8),
              _buildDetailRow('Notes', collection.notes!),
            ],
            
            const SizedBox(height: AppTheme.spacing16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showRejectDialog(collection, notifier),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showApproveDialog(collection, notifier),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacing4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Text(
            value,
            style: AppTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showApproveDialog(Collection collection, CollectionsNotifier notifier) {
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to approve this collection from ${collection.supplierName}?'),
            const SizedBox(height: AppTheme.spacing16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Approval Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _approveCollection(collection, notifier, notesController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(Collection collection, CollectionsNotifier notifier) {
    String selectedReason = _rejectionReasons.first;
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Reject Collection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to reject this collection from ${collection.supplierName}?'),
              const SizedBox(height: AppTheme.spacing16),
              const Text('Rejection Reason:'),
              const SizedBox(height: AppTheme.spacing8),
              DropdownButtonFormField<String>(
                value: selectedReason,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: _rejectionReasons.map((reason) {
                  return DropdownMenuItem(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedReason = value!;
                  });
                },
              ),
              const SizedBox(height: AppTheme.spacing16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Additional Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _rejectCollection(collection, notifier, selectedReason, notesController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reject'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _approveCollection(Collection collection, CollectionsNotifier notifier, String notes) async {
    try {
      await notifier.approveCollection(
        collectionId: collection.id,
        notes: notes.isNotEmpty ? notes : null,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Collection from ${collection.supplierName} approved successfully!'),
            backgroundColor: AppTheme.snackbarSuccessColor,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve collection: ${error.toString()}'),
            backgroundColor: AppTheme.snackbarErrorColor,
          ),
        );
      }
    }
  }

  Future<void> _rejectCollection(Collection collection, CollectionsNotifier notifier, String reason, String notes) async {
    try {
      await notifier.rejectCollection(
        collectionId: collection.id,
        rejectionReason: reason,
        notes: notes.isNotEmpty ? notes : null,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Collection from ${collection.supplierName} rejected successfully!'),
            backgroundColor: AppTheme.snackbarSuccessColor,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject collection: ${error.toString()}'),
            backgroundColor: AppTheme.snackbarErrorColor,
          ),
        );
      }
    }
  }
}
