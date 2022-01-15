import 'package:flutter/material.dart';


//Function that makes the floating action button on homepage scroll automatically to the top when user clicks on it.
void scrollToTop(ScrollController scrollController) {
  if (scrollController.hasClients)
    scrollController.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInBack,
    );
}
