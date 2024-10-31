// ignore_for_file: unused_field, unused_import

import 'package:flutter/material.dart';
import 'package:redditech/globals.dart';
import 'package:redditech/postDefinition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyPostWidget extends StatefulWidget {
  final String title;
  final String body;
  final String user;
  final String isImage;
  final String image;
  final String sub;
  const MyPostWidget(
      this.title, this.user, this.body, this.isImage, this.image, this.sub,
      {Key? key})
      : super(key: key);
  @override
  _MyPostWidgetState createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.teal[700],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title And User
                  Container(
                    margin: const EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(widget.title,
                              style: const TextStyle(
                                  fontFamily: 'Roboto', fontSize: 18.0),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        top: 5.0, bottom: 0.0, left: 20.0, right: 20.0),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                              "r/" +
                                  widget.sub +
                                  " . Posted by u/" +
                                  widget.user,
                              style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12.0,
                                  fontStyle: FontStyle.italic),
                              textAlign: TextAlign.right),
                        ),
                      ],
                    ),
                  ),
                  // Image
                  Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 15, bottom: 20, right: 20, left: 20),
                          child: widget.isImage == "true"
                              ? CachedNetworkImage(
                                  imageUrl: widget.image,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator())
                              : Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(widget.body),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
