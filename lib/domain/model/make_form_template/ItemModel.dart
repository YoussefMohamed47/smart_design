import 'package:flutter/material.dart';

class ItemModel {
  //int id;
  int parentId;
 // String name;
  TextEditingController optionController;

  ItemModel( this.optionController, {this.parentId = 0});}