class UnbordingContent {
  List <String> image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'BOOKING SERVICE',
      image: ['assets/help/booking.png', 'assets/help/booking_confirmation.png'],
      discription: "Booking service is a feature that allows users to schedule "
          "and reserve services, appointments, or resources conveniently through the application. "
          "Kindly fill-out all the required fields for us to process your booking. "
  ),
  UnbordingContent(
      title: 'SERVICE MONITORING',
      image: ['assets/help/status-pointing.gif', 'assets/help/cancel-booking.png'],
      discription: "Here, you can conveniently oversee the status of the services you've requested. "
          "Additionally, you have the option to cancel your booking while its status remains unread. "
  ),
  UnbordingContent(
      title: 'ADMIN SET A SCHEDULE',
      image: ['assets/help/set-sched.png', 'assets/help/accept.png', 'assets/help/re-sched.png'],
      discription: "You will have two options: \n ACCEPT and RE-SCHED. \n \n"
          "In ACCEPT, you can choose a date provided by the admin, which will be when a handler will reach out to assist you with your concerns. \n "
          "In RE-SCHED, you provide available dates, and the admin will set a new schedule when both parties are available for you to select a suitable date. "
  ),
  UnbordingContent(
      title: 'PICKING DATES',
      image: ['assets/help/date_range.gif', 'assets/help/date_single.gif'],
      discription: "When choosing dates for your booking, \n \n "
          "For a single-day schedule, select the 'SAME DATE TWICE' and save. \n \n "
          "For schedules spanning more than one day, choose both the starting and ending dates."
  ),
  UnbordingContent(
      title: 'SERVICE ON PROCESS',
      image: ['assets/help/on-process.png'],
      discription: "This marks the final stage where your service is totally booked. "
          "A designated handler will be assigned, and contact information will be provided for your concerns."
  ),
];