import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jom_makan/pages/Admin/views/base_views.dart';
import 'package:jom_makan/pages/Admin/views/school/addFood.dart';
import 'package:jom_makan/pages/Admin/widgets/table/controller.dart';
import 'package:jom_makan/pages/Admin/widgets/table/table_item.dart';
import 'package:jom_makan/server/food/food.dart';

import '../../style/colors.dart';
import '../../widgets/table/table.dart';

class SchoolView extends AdminView {
  SchoolView({super.key});

  @override
  State<StatefulWidget> createState() => _SchoolView();
}

class _SchoolView extends AdminStateView<SchoolView> {
  late AdminTableController schoolController;
  late AdminTableController courseController;

  var itemData = [];
  final Food foodDisplay = Food();
  List<Map<String, dynamic>> _foodItems = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      final data = await foodDisplay.getFoodData();

      setState(() {
        _foodItems = data;

        

        for (int i = 0; i < _foodItems.length; i++) {
          String foodNameCorrect = 'foodName: ${_foodItems[i]['foodName']}';
          print('Food Name: ' + foodNameCorrect);

          itemData.add({
            'foodID': _foodItems[i]['foodID'],
            'foodName': _foodItems[i]['food_name'],
            'stallID': _foodItems[i]['stallID'],
            'mainCategory': _foodItems[i]['main_category'],
            'subCategory': _foodItems[i]['sub_category'],
            'foodPrice': _foodItems[i]['food_price'],
            'qtyInStock': _foodItems[i]['qty_in_stock'],
            'foodImage': _foodItems[i]['food_image'],
          });
        }

        schoolController = AdminTableController(items: [
          AdminTableItem(
              itemView: schoolItemView,
              width: 100,
              label: "Food ID",
              prop: 'foodID',
              fixed: FixedDirection.left),
          AdminTableItem(
            itemView: schoolItemView,
            width: 150,
            label: "Food Name",
            prop: 'foodName',
          ),
          AdminTableItem(
            itemView: schoolItemView,
            width: 150,
            label: "Stall ID",
            prop: 'stallID',
          ),
          AdminTableItem(
            itemView: schoolItemView,
            width: 150,
            label: "Main Category",
            prop: 'mainCategory',
          ),
          AdminTableItem(
            itemView: schoolItemView,
            width: 150,
            label: "Sub Category",
            prop: 'subCategory',
          ),
          AdminTableItem(
              itemView: schoolItemView,
              width: 100,
              label: "Food Price",
              prop: 'foodPrice'),
          AdminTableItem(
              itemView: schoolItemView,
              width: 200,
              label: "Quantity",
              prop: 'qtyInStock'),
          AdminTableItem(
              itemView: schoolItemView,
              width: 200,
              label: "Food Image",
              prop: 'foodImage'),
          
          AdminTableItem(
              itemView: schoolItemView,
              width: 100,
              label: "操作",
              fixed: FixedDirection.right,
              prop: 'action'),
        ]);
        schoolController.setNewData(itemData);
      });
    } catch (e) {
      print('Error loading promotion data: $e');
    }
  }

  Widget schoolItemView(
      BuildContext context, int index, dynamic data, AdminTableItem item) {
    if (index == -1) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          item.label,
          style: TextStyle(color: AdminColors()
              .get()
              .secondaryColor),
        ),
      );
    } else {
      if (item.prop == 'action') {
        return Container(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
        onTap: () {
          // Call the function to delete the item at index
          _deleteItem(index);
        },
        child: const Text(
          "Delete",
          style: TextStyle(color: Colors.red, fontSize: 15),
        ),
      ),
      const SizedBox(width: 10),
              const Text("更多",
                style: TextStyle(color: Colors.blueAccent, fontSize: 15),),
            ],
          ),
        );
      }
      return Container(
        alignment: Alignment.center,
        child: Text(
          "${schoolController.ofData(index)[item.prop!]}",
          style: TextStyle(color: AdminColors()
              .get()
              .secondaryColor),
        ),
      );
    }
  }


  // Function to delete the item at the specified index
  void _deleteItem(int index) {
    setState(() {
       if (index >= 0 && index < _foodItems.length) {
      // Remove the item from the _promoItems list
      var deletedItem = _foodItems.removeAt(index);
print('deleteItem:  + $deletedItem');

      // for (int i = 0; i < _promoItems.length; i++) {
       
      // Remove the item from the itemData list
      itemData.removeWhere((item) =>
          item['foodID'] == deletedItem['foodID'] &&
          item['food_name'] == deletedItem['food_name'] &&
          item['stallID'] == deletedItem['stallID'] &&
          item['main_category'] == deletedItem['main_category'] &&
          item['sub_category'] == deletedItem['sub_category'] &&
          item['food_price'] == deletedItem['food_price'] &&
          item['qty_in_stock'] == deletedItem['qty_in_stock'] &&
          item['food_image'] == deletedItem['food_image']);
       
       // Delete the item from the database
      foodDisplay.deleteFood(deletedItem['foodID']);


      // Update the table controller with the new data
    schoolController.setNewData(itemData);
      }
    });
  }


  
  @override
  Widget? buildForLarge(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Container(
        width: size.maxWidth,
        margin: const EdgeInsets.all(20),
        height: size.maxHeight,
         child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                 // Navigate to a new page when the button is pressed
                Navigator.push(
                 context,
                MaterialPageRoute(builder: (context) => addFood()));
              },
              child: Text('Add Food'),
            ),
            SizedBox(height: 10), // Add some space between button and table
            Expanded(
              child: AdminTable(
                controller: schoolController,
                fixedHeader: true,
              ),
            ),
          ],
        ),
      );
    });
  }
}