class ChatInboxModel {
  dynamic conId;
  dynamic listingId;
  dynamic senderId;
  dynamic recipientId;
  dynamic senderDelete;
  dynamic recipientDelete;
  dynamic lastMessageId;
  dynamic senderReview;
  dynamic recipientReview;
  dynamic invertReview;
  List<Messages>? messages;

  ChatInboxModel(
      {this.conId,
        this.listingId,
        this.senderId,
        this.recipientId,
        this.senderDelete,
        this.recipientDelete,
        this.lastMessageId,
        this.senderReview,
        this.recipientReview,
        this.invertReview,
        this.messages});

  ChatInboxModel.fromJson(Map<String, dynamic> json) {
    conId = json['con_id'];
    listingId = json['listing_id'];
    senderId = json['sender_id'];
    recipientId = json['recipient_id'];
    senderDelete = json['sender_delete'];
    recipientDelete = json['recipient_delete'];
    lastMessageId = json['last_message_id'];
    senderReview = json['sender_review'];
    recipientReview = json['recipient_review'];
    invertReview = json['invert_review'];
    if (json['messages'] != null) {
      messages = <Messages>[];
      json['messages'].forEach((v) {
        messages!.add(new Messages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['con_id'] = this.conId;
    data['listing_id'] = this.listingId;
    data['sender_id'] = this.senderId;
    data['recipient_id'] = this.recipientId;
    data['sender_delete'] = this.senderDelete;
    data['recipient_delete'] = this.recipientDelete;
    data['last_message_id'] = this.lastMessageId;
    data['sender_review'] = this.senderReview;
    data['recipient_review'] = this.recipientReview;
    data['invert_review'] = this.invertReview;
    if (this.messages != null) {
      data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  dynamic messageId;
  dynamic conId;
  dynamic sourceId;
  dynamic message;
  dynamic isRead;
  dynamic createdAt;

  Messages(
      {this.messageId,
        this.conId,
        this.sourceId,
        this.message,
        this.isRead,
        this.createdAt});

  Messages.fromJson(Map<String, dynamic> json) {
    messageId = json['message_id'];
    conId = json['con_id'];
    sourceId = json['source_id'];
    message = json['message'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message_id'] = this.messageId;
    data['con_id'] = this.conId;
    data['source_id'] = this.sourceId;
    data['message'] = this.message;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    return data;
  }
}
