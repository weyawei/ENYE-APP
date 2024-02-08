class ResponsiveTextUtils {
  static bool getLayout(double width) {
    if (width <= 500) {
      return true;
    } else if (width > 500 && width <= 1100) {
      return false;
    } else {
      return false;
    }
  }

  static double getSmallFontSize(double width) {
    if (width <= 500) {
      return 10.0;
    } else if (width > 500 && width <= 1100) {
      return 16.0;
    } else {
      return 20.0;
    }
  }

  static double getNormalFontSize(double width) {
    if (width <= 500) {
      return 12.0;
    } else if (width > 500 && width <= 1100) {
      return 21.0;
    } else {
      return 29.0;
    }
  }

  static double getExtraFontSize(double width) {
    if (width <= 500) {
      return 16.0;
    } else if (width > 500 && width <= 1100) {
      return 23.0;
    } else {
      return 33.0;
    }
  }

  static double getXXFontSize(double width) {
    if (width <= 500) {
      return 24.0;
    } else if (width > 500 && width <= 1100) {
      return 37.0;
    } else {
      return 47.0;
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
