class ResponsiveTextUtils {
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
      return 14.0;
    } else if (width > 500 && width <= 1100) {
      return 20.0;
    } else {
      return 26.0;
    }
  }

  static double getXXFontSize(double width) {
    if (width <= 500) {
      return 20.0;
    } else if (width > 500 && width <= 1100) {
      return 26.0;
    } else {
      return 32.0;
    }
  }

  static double getXXXFontSize(double width) {
    if (width <= 500) {
      return 28.0;
    } else if (width > 500 && width <= 1100) {
      return 34.0;
    } else {
      return 40.0;
    }
  }
}
