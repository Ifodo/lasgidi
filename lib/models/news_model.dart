

import 'activity_model.dart';

class NewsListItem {
  String? imageUrl;
  String? date;
  String? content;
  String? title;
  String? url;
  List<Activity>? activities;

  NewsListItem({
    this.imageUrl,
    this.date,
    this.content,
    this.title,
    this.url,
    this.activities,
  });

  factory NewsListItem.fromJSON(Map<String, dynamic> json) {
    return NewsListItem(
        imageUrl: json["image"],
        title: json["title"],
        content: json["content"],
        date: json["date"],
        url: json["link"]
    );
  }
}




/*

List<Activity> activities = [
  Activity(
    imageUrl: 'assets/images/stmarksbasilica.jpg',
    name: 'St. Mark\'s Basilica',
    type: 'Sightseeing Tour',
    startTimes: ['9:00 am', '11:00 am'],
    rating: 5,
    price: 30,
  ),
  Activity(
    imageUrl: 'assets/images/gondola.jpg',
    name: 'Walking Tour and Gonadola Ride',
    type: 'Sightseeing Tour',
    startTimes: ['11:00 pm', '1:00 pm'],
    rating: 4,
    price: 210,
  ),
  Activity(
    imageUrl: 'assets/images/murano.jpg',
    name: 'Murano and Burano Tour',
    type: 'Sightseeing Tour',
    startTimes: ['12:30 pm', '2:00 pm'],
    rating: 3,
    price: 125,
  ),
];
*/

/*
List<NewsListItem> destinations = [
  NewsListItem(
    imageUrl: 'assets/images/venice.jpg',
    date: 'Venice',
    content: 'Italy',
    title: 'Visit Venice for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  NewsListItem(
    imageUrl: 'assets/images/paris.jpg',
    date: 'Paris',
    content: 'France',
    title: 'Visit Paris for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  NewsListItem(
    imageUrl: 'assets/images/newdelhi.jpg',
    date: 'New Delhi',
    content: 'India',
    title: 'Visit New Delhi for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  NewsListItem(
    imageUrl: 'assets/images/saopaulo.jpg',
    date: 'Sao Paulo',
    content: 'Brazil',
    title: 'Visit Sao Paulo for an amazing and unforgettable adventure.',
    activities: activities,
  ),
  NewsListItem(
    imageUrl: 'assets/images/newyork.jpg',
    date: 'New York City',
    content: 'United States',
    title: 'Visit New York for an amazing and unforgettable adventure.',
    activities: activities,
  ),
];
*/
