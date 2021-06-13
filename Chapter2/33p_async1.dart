void main() {
  checkVersion();
  print('end process');
}
Future checkVersion() async {
  var version = await lookUpVersion();
  // Do something with version
  print(version);
}

int lookUpVersion(){
  return 12;
}
