import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_biller/core/constants/colors.dart';
import 'package:green_biller/features/reports/stock_report/controllers/stock_movement_controller.dart';

class StockMovementPage extends StatefulWidget {
  const StockMovementPage({super.key});

  @override
  State<StockMovementPage> createState() => _StockMovementPageState();
}

class _StockMovementPageState extends State<StockMovementPage> {
  final controller = StockMovementController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onControllerUpdate);
    controller.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Stock Movement',
          style: TextStyle(color: textPrimaryColor),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimaryColor),
          onPressed: () => context.go("/reports"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Selection Card
            Card(
              elevation: 2,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.store, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          'Select Store',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: controller.selectedStore,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: textLightColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: textLightColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: accentColor),
                        ),
                        filled: true,
                        fillColor: cardColor,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: controller.stores.map((store) {
                        return DropdownMenuItem(
                          value: store,
                          child: Text(store),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.updateStore(value!);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date Range Selection
            Card(
              elevation: 2,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calendar_today, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          'Date Range',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.startDateController,
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              labelStyle:
                                  const TextStyle(color: textSecondaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: textLightColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: textLightColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: accentColor),
                              ),
                              filled: true,
                              fillColor: cardColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: textSecondaryColor,
                              ),
                            ),
                            readOnly: true,
                            onTap: () => controller.selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: controller.endDateController,
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              labelStyle:
                                  const TextStyle(color: textSecondaryColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: textLightColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: textLightColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: accentColor),
                              ),
                              filled: true,
                              fillColor: cardColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_today,
                                size: 20,
                                color: textSecondaryColor,
                              ),
                            ),
                            readOnly: true,
                            onTap: () => controller.selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Movement Type Filter
            Card(
              elevation: 2,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.swap_horiz, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          'Movement Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildFilterChip('All'),
                        _buildFilterChip('In'),
                        _buildFilterChip('Out'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Generate Report Button
            Center(
              child: ElevatedButton(
                onPressed: () => controller.generateReport(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 45),
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Generate Report',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Results Section
            Expanded(
              child: controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: accentColor,
                      ),
                    )
                  : controller.movements.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64,
                                color: textSecondaryColor,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No movements found for the selected criteria',
                                style: TextStyle(
                                  color: textSecondaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: controller.movements.length,
                          itemBuilder: (context, index) {
                            final movement = controller.movements[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 1,
                              color: cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: movement.type == 'In'
                                        ? successColor.withOpacity(0.1)
                                        : errorColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    movement.type == 'In'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: movement.type == 'In'
                                        ? successColor
                                        : errorColor,
                                  ),
                                ),
                                title: Text(
                                  movement.productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textPrimaryColor,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      '${movement.type} - ${movement.quantity} units',
                                      style: const TextStyle(
                                        color: textSecondaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      movement.date,
                                      style: const TextStyle(
                                        color: textSecondaryColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: accentLightColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '₹${movement.value.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: accentColor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = controller.selectedMovementType == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        controller.updateMovementType(label);
      },
      backgroundColor: cardColor,
      selectedColor: accentLightColor,
      checkmarkColor: accentColor,
      labelStyle: TextStyle(
        color: isSelected ? accentColor : textSecondaryColor,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected ? accentColor : textLightColor,
        ),
      ),
    );
  }
}
