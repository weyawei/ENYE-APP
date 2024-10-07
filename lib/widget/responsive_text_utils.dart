class ResponsiveTextUtils {
  static bool getLayout(double width) {
    if (width < 600) {
      return true;
    } else if (width >= 600 && width <= 1100) {
      return false;
    } else {
      return false;
    }
  }

  static double getXSmallFontSize(double width) {
    if (width <= 600) {
      return 8.0;
    } else if (width > 600 && width <= 800) {
      return 11.0;
    } else if (width > 800 && width <= 1100) {
      return 15.0;
    } else {
      return 21.0;
    }
  }

  static double getSmallFontSize(double width) {
    if (width <= 600) {
      return 10.0;
    } else if (width > 600 && width <= 800) {
      return 13.0;
    } else if (width > 800 && width <= 1100) {
      return 17.0;
    } else {
      return 23.0;
    }
  }

  static double getNormalFontSize(double width) {
    if (width <= 600) {
      return 13.0;
    } else if (width > 600 && width <= 800) {
      return 17.0;
    } else if (width > 800 && width <= 1100) {
      return 24.0;
    } else {
      return 29.0;
    }
  }

  static double getExtraFontSize(double width) {
    if (width <= 600) {
      return 15.0;
    } else if (width > 600 && width <= 800) {
      return 21.0;
    } else if (width > 800 && width <= 1100) {
      return 28.0;
    } else {
      return 33.0;
    }
  }

  static double getXFontSize(double width) {
    if (width <= 600) {
      return 17.0;
    } else if (width > 600 && width <= 800) {
      return 23.0;
    } else if (width > 800 && width <= 1100) {
      return 30.0;
    } else {
      return 35.0;
    }
  }

  static double getXXFontSize(double width) {
    if (width <= 600) {
      return 23.0;
    } else if (width > 600 && width <= 800) {
      return 29.0;
    } else if (width > 800 && width <= 1100) {
      return 37.0;
    } else {
      return 47.0;
    }
  }

  static double getXXXFontSize(double width) {
    if (width <= 600) {
      return 29.0;
    } else if (width > 600 && width <= 800) {
      return 36.0;
    } else if (width > 800 && width <= 1100) {
      return 47.0;
    } else {
      return 57.0;
    }
  }
}
