class PaymentHistoryModel {
  List<Datum>? data;
  Pagination? pagination;

  PaymentHistoryModel({this.data, this.pagination});

  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Datum>[];
      json['data'].forEach((v) {
        data!.add(Datum.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Datum {
  dynamic? id;
  dynamic? price;
  dynamic? method;
  dynamic? status;
  dynamic? transactionId;
  dynamic? orderKey;
  dynamic? paidDate;
  dynamic? createdDate;
  Gateway? gateway;

  Datum({
    this.id,
    this.price,
    this.method,
    this.status,
    this.transactionId,
    this.orderKey,
    this.paidDate,
    this.createdDate,
    this.gateway,
  });

  Datum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    method = json['method'];
    status = json['status'];
    transactionId = json['transaction_id'];
    orderKey = json['order_key'];
    paidDate = json['paid_date'];
    createdDate = json['created_date'];

    // Handle the case where gateway is an empty string
    final gatewayJson = json['gateway'];
    if (gatewayJson is Map<String, dynamic> || gatewayJson == null) {
      gateway = gatewayJson != null ? Gateway.fromJson(gatewayJson) : null;
    } else {
      // Handle the case where gateway is a string
      gateway = Gateway(
        id: null,
        title: gatewayJson,
        icon: null,
        description: null,
        key: null,
        routes: null,
        instructions: null,
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price'] = price;
    data['method'] = method;
    data['status'] = status;
    data['transaction_id'] = transactionId;
    data['order_key'] = orderKey;
    data['paid_date'] = paidDate;
    data['created_date'] = createdDate;
    if (gateway != null) {
      data['gateway'] = gateway!.toJson();
    }
    return data;
  }
}

class Gateway {
  dynamic? id;
  dynamic? title;
  dynamic? icon;
  dynamic? description;
  dynamic? key;
  Routes? routes;
  dynamic? instructions;

  Gateway({
    this.id,
    this.title,
    this.icon,
    this.description,
    this.key,
    this.routes,
    this.instructions,
  });

  Gateway.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    icon = json['icon'];
    description = json['description'];
    key = json['key'];
    routes = json['routes'] != null ? Routes.fromJson(json['routes']) : null;
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['icon'] = icon;
    data['description'] = description;
    data['key'] = key;
    if (routes != null) {
      data['routes'] = routes!.toJson();
    }
    data['instructions'] = instructions;
    return data;
  }
}

class Routes {
  dynamic? confirmPaymentIntent;

  Routes({this.confirmPaymentIntent});

  Routes.fromJson(Map<String, dynamic> json) {
    confirmPaymentIntent = json['confirm_payment_intent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['confirm_payment_intent'] = confirmPaymentIntent;
    return data;
  }
}

class Pagination {
  dynamic? total;
  dynamic? count;
  dynamic? perPage;
  dynamic? currentPage;
  dynamic? totalPages;

  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['count'] = count;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['total_pages'] = totalPages;
    return data;
  }
}
