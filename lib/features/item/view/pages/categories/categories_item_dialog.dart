import 'package:flutter/material.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/item/model/item/item_model.dart';
import 'package:green_biller/features/item/services/category/view_categories_service.dart';

class CategoryItemsDialog extends StatefulWidget {
  final String categoryName;
  final String? accessToken;
  final int categoryId;

  const CategoryItemsDialog({
    super.key,
    required this.categoryName,
    this.accessToken,
    required this.categoryId,
  });

  @override
  State<CategoryItemsDialog> createState() => _CategoryItemsDialogState();
}

class _CategoryItemsDialogState extends State<CategoryItemsDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Item> _items = [];
  List<Item> _filteredItems = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadItems();
    // _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadItems() async {
    setState(() => _isLoading = true);

    try {
      // Replace this with your actual API call
      final items = await getItemsBasedOnCateId(
          widget.accessToken!, widget.categoryId.toString());

      _items = items;
      _filteredItems = items;
    } catch (e) {
      print(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(widget.categoryName),
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimaryColor,
                        ),
                      ),
                      Text(
                        '${_filteredItems.length} items',
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondaryColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and Filter Bar
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search items...',
                        hintStyle: TextStyle(color: textLightColor),
                        prefixIcon:
                            Icon(Icons.search, color: textSecondaryColor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilter,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All Items')),
                      DropdownMenuItem(value: 'Active', child: Text('Active')),
                      DropdownMenuItem(
                          value: 'Inactive', child: Text('Inactive')),
                      DropdownMenuItem(
                          value: 'In Stock', child: Text('In Stock')),
                      DropdownMenuItem(
                          value: 'Out of Stock', child: Text('Out of Stock')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                      // _filterItems();
                    },
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: textSecondaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Items List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: accentColor),
                    )
                  : _filteredItems.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return _buildItemCard(item);
                          },
                        ),
            ),

            // Footer Actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: textSecondaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add new item to this category
                    Navigator.of(context).pop();
                    // Navigate to add item page with category pre-selected
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildItemCard(Item item) {
    const isActive = true;
    int stock = int.tryParse(item.openingStock) ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Item Image/Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: item.itemImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.itemImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.inventory, color: accentColor),
                    ),
                  )
                : const Icon(Icons.inventory, color: accentColor, size: 24),
          ),
          const SizedBox(width: 16),

          // Item Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: textPrimaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isActive ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.sku,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondaryColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.salesPrice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: stock > 0
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: $stock',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: stock > 0 ? Colors.blue : Colors.orange,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          // Actions
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: textSecondaryColor.withOpacity(0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 18, color: accentColor),
                    SizedBox(width: 8),
                    Text('View Details'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: accentColor),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: isActive ? 'deactivate' : 'activate',
                child: Row(
                  children: [
                    Icon(
                      isActive ? Icons.block : Icons.check_circle,
                      size: 18,
                      color: isActive ? Colors.orange : Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text(isActive ? 'Deactivate' : 'Activate'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: errorColor),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
            onSelected: (value) => _handleItemAction(value, item),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: textSecondaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No items found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textSecondaryColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Add items to this category to see them here',
            style: TextStyle(
              fontSize: 14,
              color: textSecondaryColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to add item page
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add First Item'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleItemAction(String action, Item item) {
    switch (action) {
      case 'view':
        // Show item details
        _showItemDetailsDialog(item);
        break;
      case 'edit':
        // Navigate to edit item page
        Navigator.of(context).pop();
        break;
      case 'activate':
      case 'deactivate':
        // Toggle item status
        // setState(() {
        //   isActive = !isActive;
        // });
        // _filterItems();
        break;
      case 'delete':
        // Show delete confirmation
        _showDeleteConfirmation(item);
        break;
    }
  }

  void _showItemDetailsDialog(Item item) {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(item.itemName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('SKU: ${item.sku}'),
              Text('Price: ₹${item.salesPrice}'),
              Text('Stock: ${item.openingStock}'),
              const Text('Status: Active '),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Description: ${item.description}'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e, stack) {
      print(stack.toString());
    }
  }

  void _showDeleteConfirmation(Item item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.itemName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.remove(item);
                _filteredItems.remove(item);
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: errorColor),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electronics':
        return Icons.electrical_services;
      case 'clothing':
        return Icons.checkroom;
      case 'food & beverages':
        return Icons.restaurant;
      case 'office supplies':
        return Icons.work;
      case 'home & kitchen':
        return Icons.home;
      case 'beauty & personal care':
        return Icons.spa;
      case 'sports & outdoors':
        return Icons.sports_soccer;
      case 'books & stationery':
        return Icons.menu_book;
      case 'automotive':
        return Icons.directions_car;
      case 'health & wellness':
        return Icons.medical_services;
      case 'toys & games':
        return Icons.toys;
      case 'jewelry':
        return Icons.diamond;
      case 'pet supplies':
        return Icons.pets;
      case 'garden & outdoor':
        return Icons.yard;
      case 'music & instruments':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }
}

// Function to show the dialog (to be called from the main categories page)
void showCategoryItemsDialog(
  BuildContext context, {
  required String categoryName,
  String? accessToken,
  required int categoryId,
}) {
  showDialog(
    context: context,
    builder: (context) => CategoryItemsDialog(
      categoryName: categoryName,
      accessToken: accessToken,
      categoryId: categoryId,
    ),
  );
}
