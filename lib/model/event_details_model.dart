
class EventDetailsModel {
  final String id;
  final String senderId;
  final String title;
  final String eventType;
  final String eventFormat;
  final String startDate;
  final String startTime;
  final String attendees;
  final String orders;
  final String receipts;
  final String tickets;
  final String addOns;
  final String ticketGroups;
  final String couponCodes;
  final String forms;
  final String eventlogo;

  EventDetailsModel({
    required this.id,
    required this.senderId,
    required this.title,
    required this.eventType,
    required this.eventFormat,
    required this.startDate,
    required this.startTime,
    required this.attendees,
    required this.orders,
    required this.receipts,
    required this.tickets,
    required this.addOns,
    required this.ticketGroups,
    required this.couponCodes,
    required this.forms,
    required this.eventlogo
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) {
    return EventDetailsModel(
      id: json['_id'] as String,
      senderId: json['sender_id'] as String,
      title: json['title'] as String,
      eventType: json['event_type'] as String,
      eventFormat: json['event_format'] as String,
      startDate: json['start_date'] as String,
      startTime: json['start_time'] as String,
      // eventlogo: json['event_logo'].toString(),
      attendees: json['statistics']['attendees'].toString(),
      orders: json['statistics']['orders'].toString(),
      receipts: json['statistics']['receipts'].toString(),
      tickets: json['statistics']['tickets'].toString(),
      addOns: json['statistics']['add_ons'].toString(),
      ticketGroups: json['statistics']['ticket_groups'].toString(),
      couponCodes: json['statistics']['coupon_codes'].toString(),
      forms: json['statistics']['forms'].toString(),
      eventlogo: json['event_logo'].toString(),
    );
  }
}

