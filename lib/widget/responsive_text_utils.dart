class ResponsiveTextUtils {
  static double getSmallFontSize(double width) {
    if (width <= 500) {
      return 10.0;
    } else if (width > 500 && width <= 1100) {
      return 14.0;
    } else {
      return 18.0;
    }
  }

  static double getNormalFontSize(double width) {
    if (width <= 500) {
      return 12.0;
    } else if (width > 500 && width <= 1100) {
      return 18.0;
    } else {
      return 24.0;
    }
  }

  static double getExtraFontSize(double width) {
    if (width <= 500) {
      return 16.0;
    } else if (width > 500 && width <= 1100) {
      return 22.0;
    } else {
      return 28.0;
    }
  }

  static double getXXFontSize(double width) {
    if (width <= 500) {
      return 24.0;
    } else if (width > 500 && width <= 1100) {
      return 34.0;
    } else {
      return 44.0;
    }
  }

  static double getXXXFontSize(double width) {
    if (width <= 500) {
      return 36.0;
    } else if (width > 500 && width <= 1100) {
      return 50.0;
    } else {
      return 56.0;
    }
  }
}
