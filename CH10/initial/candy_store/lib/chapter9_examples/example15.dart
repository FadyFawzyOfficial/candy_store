void main() async {
  final sw = Stopwatch()..start();

  //! 1. we created a Future for each search result we needed. Remember, the Future
  //! is posted on the event loop at the time of creation, so it starts executing
  //! immediately, even without await.
  final searchResultFuture = search('candy');
  final searchResultFuture2 = search('chocolate');
  final searchResultFuture3 = search('ice cream');

  //! 2. Since we depend on the search results for our map functions, we need to
  //! await the results. So we created futures for ou map results.
  //! While we await the first search, the second and third are executed
  //! simultaneously, saving us time.
  final mapResultFuture = map(await searchResultFuture);
  final mapResultFuture2 = map(await searchResultFuture2);
  final mapResultFuture3 = map(await searchResultFuture3);

  //! 3. Finally, we kickstart three of our map functions and now we just need
  //! to wait for them. Since the map functions are independent, we don't need to
  //! await each one individually. Instead we can use Future.wait to kickstart all of them
  final results = await Future.wait([
    mapResultFuture,
    mapResultFuture2,
    mapResultFuture3,
  ]);

  print(results);

  sw.stop();
  print('Total time: ${sw.elapsedMilliseconds}ms');
}

Future<String> search(String query) async {
  // Simulate network delay
  await Future.delayed(const Duration(seconds: 3));
  return 'Search results for $query';
}

Future<String> map(String query) async {
  await Future.delayed(const Duration(seconds: 3));
  return 'Mapped: $query';
}
