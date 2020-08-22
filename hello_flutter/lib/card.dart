import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final _imageWidth = 60.0;
  final int index;

  const ContactCard({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400.withOpacity(0.7),
              blurRadius: 3,
              spreadRadius: 0.8,
              offset: Offset(0, 2),
            )
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Row(children: [
              CircleAvatar(
                radius: _imageWidth / 2,
                backgroundImage: AssetImage("images/flutter.jpg"),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Text(
                "Theinmwe $index",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Text(
                "Developer",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class ContactCardLand extends StatelessWidget {
  final int index;

  const ContactCardLand({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage("images/flutter.jpg"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Theinmwe Naing $index",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Developer",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
